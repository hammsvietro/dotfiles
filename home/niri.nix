{
  osConfig,
  lib,
  pkgs,
  ...
}:

let
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
  # the workspace to the focused output, so it follows the cursor instead of jumping there.
  focusBinds = lib.concatMapStringsSep "\n        " (
    w:
    ''Mod+${w.key} { spawn-sh "o=''$(niri msg -j focused-output | jq -r .name); niri msg action move-workspace-to-monitor \"''$o\" --reference ${w.name}; niri msg action focus-workspace ${w.name}"; }''
  ) workspaceKeys;

  moveBinds = lib.concatMapStringsSep "\n        " (
    w: ''Mod+Shift+${w.key} { move-window-to-workspace "${w.name}" focus=false; }''
  ) workspaceKeys;
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
            active-gradient from="#33ccffee" to="#00ff99ee" angle=45
            inactive-color "#59595955"
        }
    }

    prefer-no-csd

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

    window-rule {
        geometry-corner-radius 20
        clip-to-geometry true
        shadow {
            on
            softness 30
            spread 4
            offset x=0 y=5
            color "#00000055"
        }
    }

    window-rule {
        match app-id="thunar"
        opacity 0.90
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
        Mod+E { spawn "thunar"; }
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
