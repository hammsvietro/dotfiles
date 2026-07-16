# Hyprland/portal packages come from the system config; noctalia-shell regenerates
# theme files under ~/.config/hypr at runtime, so only individual files are managed here.
{ pkgs, ... }:

let
  screensaverStart = pkgs.writeShellScript "screensaver-start" ''
    ${pkgs.procps}/bin/pgrep -x glslViewer >/dev/null && exit 0
    exec ${pkgs.glslviewer}/bin/glslViewer ${./screensaver/mandelbrot.frag} --noncurses --nocursor
  '';
  screensaverStop = pkgs.writeShellScript "screensaver-stop" ''
    ${pkgs.procps}/bin/pkill -x glslViewer
  '';
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "hyprlang";
    package = null;
    portalPackage = null;
    systemd.enable = true;

    settings = {
      "$ipc" = "noctalia-shell ipc call";
      "$mainMod" = "SUPER";

      env = [
        "LIBVA_DRIVER_NAME,nvidia"
        "XDG_SESSION_TYPE,wayland"
        "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "WLR_RENDERER_ALLOW_SOFTWARE,1"
        "NVD_BACKEND,direct"
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "QT_QPA_PLATFORM,wayland;xcb"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        "MOZ_ENABLE_WAYLAND,1"
        "GDK_SCALE,1"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "NIXOS_OZONE_WL, 1"
        "ELECTRON_OZONE_PLATFORM_HINT,auto"
        "ELECTRON_ENABLE_WAYLAND,1"
      ];

      monitor = [
        "DP-1, 1920x1080@144, 0x0, 1"
        "HDMI-A-1, 2560x1080@60, 1920x0, 1"
        "eDP-1,preferred,auto,1"
        "eDP-2,preferred,auto,1"
      ];

      exec-once = [
        "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "dbus-update-activation-environment --systemd --all"
        "gpgconf --launch gpg-agent"
        "dbus-update-activation-environment --systemd SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)"
        "gpg-connect-agent updatestartuptty /bye > /dev/null"
        "systemctl --user start hyprpolkitagent"
        "polkit-kde-agent"
        "emacs --daemon"
        "noctalia-shell"
        "pywalfox start"
        "xwaylandvideobridge"
        "copyq --start-server"
      ];

      input = {
        kb_layout = "us,br";
        kb_options = "grp:alt_space_toggle";
        follow_mouse = 1;
        mouse_refocus = false;
        force_no_accel = 0;
        touchpad = {
          natural_scroll = true;
          scroll_factor = 1.0;
          tap-to-click = true;
          clickfinger_behavior = true;
        };
        sensitivity = 0;
      };

      gestures = {
        workspace_swipe_distance = 300;
        workspace_swipe_invert = false;
        workspace_swipe_cancel_ratio = 0.5;
        workspace_swipe_create_new = true;
      };

      cursor = {
        no_hardware_cursors = true;
      };

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 1;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "master";
        allow_tearing = true;
      };

      render = {
        direct_scanout = 2;
      };

      decoration = {
        rounding = 20;
        rounding_power = 2;
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
        blur = {
          enabled = true;
          size = 3;
          passes = 2;
          vibrancy = 0.1696;
        };
      };

      animations = {
        enabled = true;
        bezier = [ "myBezier, 0.05, 0.9, 0.1, 1.05" ];
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
          "specialWorkspace, 1, 6, default, slidevert"
        ];
      };

      misc = {
        disable_hyprland_logo = true;
        focus_on_activate = false;
        on_focus_under_fullscreen = 1;
        exit_window_retains_fullscreen = true;
        vrr = 2;
      };

      windowrule = [
        "immediate on, match:class ^(steam_app_.*)$"
        "match:class ^([Tt]hunar)$, opacity 0.90 0.82"
        "match:class ^(emacs)$, workspace 3"
        "match:class ^(discord)$, workspace 6"
        "match:class ^(notion-app)$, workspace 7"
        "match:class ^(obsidian)$, workspace 7"
        "match:class ^(com.stremio.stremio)$, workspace 9"
        "match:class ^([Ss]team)$, match:title ^([Ss]team)$, workspace 8 silent, tile 1"
        "match:class ^([Ss]team)$, match:title ^(notificationtoasts_.*_desktop)$, no_focus 1"
        "match:class ^(xwaylandvideobridge)$, opacity 0.0 0.0, no_anim 1, no_initial_focus 1, no_focus 1, max_size 1 1, no_blur 1"
        "match:workspace w[tv1], match:float 0, border_size 0, rounding 0"
        "match:workspace f[1], match:float 0, border_size 0, rounding 0"
        "match:class ^(xwaylandvideobridge)$, opacity 0.0 0.0"
        "match:class ^(xwaylandvideobridge)$, no_anim on"
        "match:class ^(xwaylandvideobridge)$, no_initial_focus on"
        "match:class ^(xwaylandvideobridge)$, max_size 1 1"
        "match:class ^(xwaylandvideobridge)$, no_blur on"
        "match:class ^([Ss]team)$, match:title ^([Ss]team)$, workspace 8 silent"
        "match:class ^([Ss]team)$, match:title ^([Ss]team)$, tile on"
        "match:class ^(steam)$, match:title ^(notificationtoasts_.*_desktop)$, no_focus on"
        "stay_focused 1, match:title ^()$, match:class ^(steam)$"
        "min_size 1 1, match:title ^()$, match:class ^(steam)$"
        "float true, match:class ^(GLFW-Application)$, match:title ^(GlslViewer)$"
        "fullscreen true, match:class ^(GLFW-Application)$, match:title ^(GlslViewer)$"
        "pin true, match:class ^(GLFW-Application)$, match:title ^(GlslViewer)$"
        "border_size 0, match:class ^(GLFW-Application)$, match:title ^(GlslViewer)$"
        "rounding 0, match:class ^(GLFW-Application)$, match:title ^(GlslViewer)$"
        "no_blur on, match:class ^(GLFW-Application)$, match:title ^(GlslViewer)$"
        "no_initial_focus on, match:class ^(GLFW-Application)$, match:title ^(GlslViewer)$"
      ];

      workspace = [
        "w[tv1], gapsout:0, gapsin:0"
        "f[1], gapsout:0, gapsin:0"
      ];

      bind = [
        ''$mainMod SHIFT, return, exec, sh -c "GTK_IM_MODULE=wayland ghostty"''
        "$mainMod SHIFT, Q, killactive,"
        "$mainMod SHIFT, E, exit,"
        "$mainMod, E, exec, thunar"
        "$mainMod, I, togglefloating,"
        "$mainMod, F, fullscreen"
        "$mainMod, space, layoutmsg, swapwithmaster"
        "$mainMod SHIFT, space, layoutmsg, focusmaster"
        "$mainMod SHIFT, S, exec, grimblast --notify --freeze copy area"
        ''$mainMod, PERIOD, exec, emacsclient -c -a "emacs"''
        "$mainMod, D, exec, $ipc launcher toggle"
        "$mainMod, S, exec,  $ipc controlCenter toggle"
        "$mainMod SHIFT, L, exec,  $ipc lockScreen lock"
        "$mainMod CTRL SHIFT, L, exec,  $ipc sessionMenu lockAndSuspend"
        "SUPER, comma, exec, $ipc settings toggle"
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"
        "$mainMod, J, layoutmsg, cyclenext"
        "$mainMod, K, layoutmsg, cycleprev"
        "$mainMod SHIFT, J, layoutmsg, swapnext"
        "$mainMod SHIFT, K, layoutmsg, swapprev"
        "$mainMod,L,resizeactive,50 0"
        "$mainMod,H,resizeactive,-50 0"
        "$mainMod, C, setfloating,"
        "$mainMod, C, centerwindow,"
        "$mainMod SHIFT, C, setfloating,"
        "$mainMod SHIFT, C, resizeactive, exact 1700 900"
        "$mainMod SHIFT, C, centerwindow,"
        "$mainMod, 1, moveworkspacetomonitor, 1 current"
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, moveworkspacetomonitor, 2 current"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, moveworkspacetomonitor, 3 current"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, moveworkspacetomonitor, 4 current"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, moveworkspacetomonitor, 5 current"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, moveworkspacetomonitor, 6 current"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, moveworkspacetomonitor, 7 current"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, moveworkspacetomonitor, 8 current"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, moveworkspacetomonitor, 9 current"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, moveworkspacetomonitor, 10 current"
        "$mainMod, 0, workspace, 10"
        "$mainMod SHIFT, 1, movetoworkspacesilent, 1"
        "$mainMod SHIFT, 2, movetoworkspacesilent, 2"
        "$mainMod SHIFT, 3, movetoworkspacesilent, 3"
        "$mainMod SHIFT, 4, movetoworkspacesilent, 4"
        "$mainMod SHIFT, 5, movetoworkspacesilent, 5"
        "$mainMod SHIFT, 6, movetoworkspacesilent, 6"
        "$mainMod SHIFT, 7, movetoworkspacesilent, 7"
        "$mainMod SHIFT, 8, movetoworkspacesilent, 8"
        "$mainMod SHIFT, 9, movetoworkspacesilent, 9"
        "$mainMod SHIFT, 0, movetoworkspacesilent, 10"
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
        "$mainMod SHIFT,O,movetoworkspace,special"
        "$mainMod, O, togglespecialworkspace"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      bindl = [
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ];

      bindel = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ];
    };

    extraConfig = ''
      source = /home/hammsvietro/.config/hypr/noctalia/noctalia-colors.conf
    '';
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "noctalia-shell ipc call lockScreen lock";
        before_sleep_cmd = "${screensaverStop}; noctalia-shell ipc call lockScreen lock";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
      listener = [
        {
          timeout = 300;
          on-timeout = "${screensaverStart}";
          on-resume = "${screensaverStop}";
        }
        {
          timeout = 600;
          on-timeout = "${screensaverStop}; noctalia-shell ipc call lockScreen lock";
        }
        {
          timeout = 900;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 1800;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}
