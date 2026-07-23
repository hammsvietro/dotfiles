{
  osConfig,
  lib,
  pkgs,
  ...
}:

let
  glass = import ./glass.nix;

  hostName = osConfig.networking.hostName;
  isMandelbrot = hostName == "mandelbrot";

  keyboard =
    if isMandelbrot then
      ''
        keyboard {
            xkb {
                layout "br"
            }
        }''
    else
      ''
        keyboard {
            xkb {
                layout "us,br"
                options "grp:alt_space_toggle"
            }
        }'';

  outputs = lib.optionalString (!isMandelbrot) ''
    output "HDMI-A-1" {
        mode "2560x1080@75.000"
        position x=0 y=0
        scale 1
    }

    output "DP-2" {
        mode "1920x1080@144.000"
        position x=2560 y=0
        scale 1
    }
  '';

  workspaceKeys = [
    {
      key = "1";
      name = "w1";
    }
    {
      key = "2";
      name = "w2";
    }
    {
      key = "3";
      name = "w3";
    }
    {
      key = "4";
      name = "w4";
    }
    {
      key = "5";
      name = "w5";
    }
    {
      key = "6";
      name = "w6";
    }
    {
      key = "7";
      name = "w7";
    }
    {
      key = "8";
      name = "w8";
    }
    {
      key = "9";
      name = "w9";
    }
    {
      key = "0";
      name = "w10";
    }
  ];

  workspaceDecls = lib.concatMapStringsSep "\n    " (w: ''workspace "${w.name}"'') workspaceKeys;

  # niri parses a numeric reference as a per-monitor index, so workspaces are named
  # non-numerically to be addressable by name from any monitor. Each switch first drags
  # the workspace to the focused output, so it follows the cursor instead of jumping there,
  # then pins it to its numbered slot so the per-output order stays ascending after moves.
  focusBinds = lib.concatMapStringsSep "\n        " (
    w:
    ''Mod+${w.key} { spawn-sh "o=''$(niri msg -j focused-output | jq -r .name); niri msg action move-workspace-to-monitor \"''$o\" --reference ${w.name}; niri msg action focus-workspace ${w.name}; niri msg action move-workspace-to-index ${lib.removePrefix "w" w.name}"; }''
  ) workspaceKeys;

  moveBinds = lib.concatMapStringsSep "\n        " (
    w: ''Mod+Shift+${w.key} { move-window-to-workspace "${w.name}" focus=false; }''
  ) workspaceKeys;

  # The laptop pays battery for the glass shader, so it runs a lighter profile: fewer blur
  # passes and the pure-realism refraction terms dropped (the frost + signature warp stay).
  blur = if isMandelbrot then glass.niri.blur // { passes = "3"; } else glass.niri.blur;
  lg =
    if isMandelbrot then
      glass.niri.liquidGlass
      // {
        physicalRefraction = "0.0";
        fringing = "0.0";
        diluteFringing = "0.0";
        lensDistortion = "0.3";
      }
    else
      glass.niri.liquidGlass;
  mkGlass = g: ''
    background-effect {
            blur true
            xray true
            liquid-glass {
                refraction-strength ${g.refractionStrength}
                power-factor ${g.powerFactor}
                refraction-power ${g.refractionPower}
                glow-weight ${g.glowWeight}
                edge-lighting ${g.edgeLighting}
                edge-thickness ${g.edgeThickness}
                edge-padding ${g.edgePadding}
                saturation ${g.saturation}
                vibrancy ${g.vibrancy}
                brightness ${g.brightness}
                contrast ${g.contrast}
                adaptive-dim ${g.adaptiveDim}
                adaptive-boost ${g.adaptiveBoost}
                physical-refraction ${g.physicalRefraction}
                lens-distortion ${g.lensDistortion}
                fringing ${g.fringing}
                refraction-dilute ${g.refractionDilute}
                dilute-strength ${g.diluteStrength}
                dilute-fringing ${g.diluteFringing}
            }
        }'';
  liquidGlass = mkGlass lg;
  panelLiquidGlass = mkGlass (lg // glass.niri.panelGlass);

  niriConfigText = ''
    input {
        ${keyboard}
        touchpad {
            tap
            natural-scroll
            click-method "clickfinger"
        }
        focus-follows-mouse
    }

    ${outputs}
    layout {
        gaps 10
        center-focused-column "never"
        default-column-width { proportion 0.5; }
        focus-ring {
            off
            width 2
            active-gradient from="${glass.niri.focusRing.activeFrom}" to="${glass.niri.focusRing.activeTo}" angle=45
            inactive-color "${glass.niri.focusRing.inactiveColor}"
        }
    }

    prefer-no-csd

    // Only tunes strength; noctalia drives the shaped blur region via ext-background-effect.
    blur {
        passes ${blur.passes}
        offset ${blur.offset}
        noise ${blur.noise}
        saturation ${blur.saturation}
    }

    animations {
        workspace-switch {
            off
        }
    }

    hotkey-overlay {
        skip-at-startup
    }

    environment {
        QT_QPA_PLATFORM "wayland;xcb"
        QT_AUTO_SCREEN_SCALE_FACTOR "1"
        MOZ_ENABLE_WAYLAND "1"
        GDK_SCALE "1"
        NIXOS_OZONE_WL "1"
        ELECTRON_OZONE_PLATFORM_HINT "auto"
        ELECTRON_ENABLE_WAYLAND "1"
    }

    spawn-at-startup "dbus-update-activation-environment" "--systemd" "--all"
    spawn-at-startup "gpgconf" "--launch" "gpg-agent"
    spawn-sh-at-startup "dbus-update-activation-environment --systemd SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)"
    spawn-sh-at-startup "gpg-connect-agent updatestartuptty /bye > /dev/null"
    spawn-at-startup "systemctl" "--user" "start" "hyprpolkitagent"
    spawn-at-startup "emacs" "--daemon"
    spawn-at-startup "noctalia-shell"
    spawn-at-startup "pywalfox" "start"
    spawn-at-startup "copyq" "--start-server"

    ${workspaceDecls}
    workspace "special"

    // Rounded corners, shadow, and the shared glass backdrop for every window. liquid-glass
    // renders only behind translucent pixels (opaque windows cover it), and needs the
    // niri-glass fork (programs.niri.package) — stock niri rejects the node.
    window-rule {
        geometry-corner-radius 20
        clip-to-geometry true
        shadow {
            on
            softness ${glass.niri.shadow.softness}
            spread ${glass.niri.shadow.spread}
            offset x=${glass.niri.shadow.offsetX} y=${glass.niri.shadow.offsetY}
            color "${glass.niri.shadow.color}"
        }
        ${liquidGlass}
    }

    // Panels get the gentler panelLiquidGlass (crisp text). Excludes the wallpaper/background/
    // exclusion layers so only noctalia's panels get the effect.
    layer-rule {
        match namespace="^noctalia-"
        exclude namespace="^noctalia-(background|wallpaper|image-cache|bar-exclusion)"
        ${panelLiquidGlass}
    }

    window-rule {
        match app-id="zen"
        draw-border-with-background false
    }

    window-rule {
        match app-id="emacs"
        open-on-workspace "w3"
    }

    window-rule {
        match app-id="discord"
        open-on-workspace "w6"
    }

    window-rule {
        match app-id="notion-app"
        open-on-workspace "w7"
    }

    window-rule {
        match app-id="obsidian"
        open-on-workspace "w7"
    }

    window-rule {
        match app-id="com.stremio.stremio"
        open-on-workspace "w9"
    }

    window-rule {
        match app-id="steam"
        open-on-workspace "w8"
    }

    window-rule {
        match app-id="GLFW-Application" title="GlslViewer"
        open-fullscreen true
    }

    binds {
        Mod+Shift+Return { spawn-sh "GTK_IM_MODULE=wayland ghostty"; }
        Mod+E { spawn "nemo"; }
        Mod+Period { spawn "emacsclient" "-c" "-a" "emacs"; }
        Mod+D { spawn "noctalia-shell" "ipc" "call" "launcher" "toggle"; }
        Mod+S { spawn "noctalia-shell" "ipc" "call" "controlCenter" "toggle"; }
        Mod+Comma { spawn "noctalia-shell" "ipc" "call" "settings" "toggle"; }
        Mod+Shift+L { spawn "noctalia-shell" "ipc" "call" "lockScreen" "lock"; }
        Mod+Ctrl+Shift+L { spawn "noctalia-shell" "ipc" "call" "sessionMenu" "lockAndSuspend"; }
        Mod+Shift+H { spawn "ghostty" "-e" "sh" "-c" "sudo nixos-rebuild switch --flake ~/dotfiles#${hostName}; exec fish"; }
        Mod+Shift+S { screenshot; }
        Print { screenshot-screen; }
        Mod+Print { screenshot-window; }

        Mod+Shift+Q { close-window; }
        Mod+Shift+E { quit; }
        Mod+F { maximize-column; }
        Mod+Shift+F { fullscreen-window; }
        Mod+I { toggle-window-floating; }
        Mod+C { center-column; }
        Mod+Shift+C { switch-focus-between-floating-and-tiling; }

        Mod+Left  { focus-column-left; }
        Mod+Right { focus-column-right; }
        Mod+Up    { focus-window-up; }
        Mod+Down  { focus-window-down; }
        Mod+K { focus-column-left; }
        Mod+J { focus-column-right; }

        Mod+Space { move-column-to-first; }
        Mod+Shift+Space { focus-column-first; }

        Mod+Shift+J { move-column-right; }
        Mod+Shift+K { move-column-left; }
        Mod+Shift+Left  { move-column-left; }
        Mod+Shift+Right { move-column-right; }
        Mod+Shift+Up    { move-window-up; }
        Mod+Shift+Down  { move-window-down; }

        Mod+L { set-column-width "+10%"; }
        Mod+H { set-column-width "-10%"; }

        Mod+BracketLeft  { consume-or-expel-window-left; }
        Mod+BracketRight { consume-or-expel-window-right; }
        Mod+R { switch-preset-column-width; }
        Mod+B { spawn "niri-toggle-border"; }

        Mod+O { focus-workspace "special"; }
        Mod+Shift+O { move-window-to-workspace "special" focus=false; }

        ${focusBinds}

        ${moveBinds}

        Mod+WheelScrollDown cooldown-ms=150 { focus-workspace-down; }
        Mod+WheelScrollUp   cooldown-ms=150 { focus-workspace-up; }

        XF86AudioRaiseVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"; }
        XF86AudioLowerVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"; }
        XF86AudioMute        allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
        XF86AudioPlay  allow-when-locked=true { spawn "playerctl" "play-pause"; }
        XF86AudioPause allow-when-locked=true { spawn "playerctl" "play-pause"; }
        XF86AudioNext  allow-when-locked=true { spawn "playerctl" "next"; }
        XF86AudioPrev  allow-when-locked=true { spawn "playerctl" "previous"; }
    }
  '';

  niriConfigFile = pkgs.writeText "niri-config.kdl" niriConfigText;

  toggleBorder = pkgs.writeShellScriptBin "niri-toggle-border" ''
    config="$HOME/.config/niri/config.kdl"
    if ${pkgs.gnused}/bin/sed -n '/focus-ring {/,/}/p' "$config" | ${pkgs.gnugrep}/bin/grep -q '/-off'; then
      ${pkgs.gnused}/bin/sed -i '/focus-ring {/,/}/ s#/-off#off#' "$config"
    else
      ${pkgs.gnused}/bin/sed -i '/focus-ring {/,/}/ s#^\( *\)off#\1/-off#' "$config"
    fi
  '';
in
{
  home.packages = [ toggleBorder ];

  home.activation.niriConfigWritable = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${pkgs.coreutils}/bin/mkdir -p "$HOME/.config/niri"
    ${pkgs.coreutils}/bin/cp --no-preserve=mode --remove-destination "${niriConfigFile}" "$HOME/.config/niri/config.kdl"
  '';
}
