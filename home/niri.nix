{ osConfig, lib, ... }:

let
  isMandelbrot = osConfig.networking.hostName == "mandelbrot";

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
    output "DP-1" {
        mode "1920x1080@144.000"
        position x=0 y=0
        scale 1
    }

    output "HDMI-A-1" {
        mode "2560x1080@60.000"
        position x=1920 y=0
        scale 1
    }
  '';
in
{
  xdg.configFile."niri/config.kdl".text = ''
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
            width 1
            active-gradient from="#33ccffee" to="#00ff99ee" angle=45
            inactive-color "#595959aa"
        }
    }

    prefer-no-csd

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

    workspace "1"
    workspace "2"
    workspace "3"
    workspace "4"
    workspace "5"
    workspace "6"
    workspace "7"
    workspace "8"
    workspace "9"
    workspace "10"
    workspace "special"

    window-rule {
        geometry-corner-radius 20
        clip-to-geometry true
    }

    window-rule {
        match app-id="thunar"
        opacity 0.90
    }

    window-rule {
        match app-id="emacs"
        open-on-workspace "3"
    }

    window-rule {
        match app-id="discord"
        open-on-workspace "6"
    }

    window-rule {
        match app-id="notion-app"
        open-on-workspace "7"
    }

    window-rule {
        match app-id="obsidian"
        open-on-workspace "7"
    }

    window-rule {
        match app-id="com.stremio.stremio"
        open-on-workspace "9"
    }

    window-rule {
        match app-id="steam"
        open-on-workspace "8"
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
        Mod+Shift+S { spawn "grimblast" "--notify" "--freeze" "copy" "area"; }
        Print { screenshot; }

        Mod+Shift+Q { close-window; }
        Mod+Shift+E { quit; }
        Mod+F { fullscreen-window; }
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

        Mod+O { focus-workspace "special"; }
        Mod+Shift+O { move-window-to-workspace "special" focus=false; }

        Mod+1 { focus-workspace "1"; }
        Mod+2 { focus-workspace "2"; }
        Mod+3 { focus-workspace "3"; }
        Mod+4 { focus-workspace "4"; }
        Mod+5 { focus-workspace "5"; }
        Mod+6 { focus-workspace "6"; }
        Mod+7 { focus-workspace "7"; }
        Mod+8 { focus-workspace "8"; }
        Mod+9 { focus-workspace "9"; }
        Mod+0 { focus-workspace "10"; }

        Mod+Shift+1 { move-window-to-workspace "1" focus=false; }
        Mod+Shift+2 { move-window-to-workspace "2" focus=false; }
        Mod+Shift+3 { move-window-to-workspace "3" focus=false; }
        Mod+Shift+4 { move-window-to-workspace "4" focus=false; }
        Mod+Shift+5 { move-window-to-workspace "5" focus=false; }
        Mod+Shift+6 { move-window-to-workspace "6" focus=false; }
        Mod+Shift+7 { move-window-to-workspace "7" focus=false; }
        Mod+Shift+8 { move-window-to-workspace "8" focus=false; }
        Mod+Shift+9 { move-window-to-workspace "9" focus=false; }
        Mod+Shift+0 { move-window-to-workspace "10" focus=false; }

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
}
