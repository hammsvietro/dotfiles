{ config, pkgs, ... }:
{
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    extraPackages = with pkgs; [ gamemode ];
    extraCompatPackages = with pkgs; [ proton-ge-bin ];
  };

  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        renice = -10;
        softrealtime = "auto";
        inhibit_screensaver = 1;
        ioprio = 0;
      };
      cpu = {
        park_cores = "no";
        pin_cores = "no";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    gamescope
    vkbasalt
    protontricks
    libstrangle
    goverlay
    fuse2
    mangohud
    protonup-qt
  ];

  environment.sessionVariables = {
    STEAM_FORCE_DESKTOPUI_SCALING = "1";
    STEAM_GAME_FORCE_GAMEMODE = "1";
    vblank_mode = "0";
  };

  systemd.user.services.steam-shader-config = {
    description = "Configure Steam shader preprocessing threads";
    wantedBy = [ "default.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    script = ''
      THREADS=$(${pkgs.coreutils}/bin/nproc)
      STEAM_THREADS=$((THREADS - 4))

      if [ $STEAM_THREADS -lt 4 ]; then
        STEAM_THREADS=4
      fi

      mkdir -p ~/.steam/steam
      echo "unShaderBackgroundProcessingThreads $STEAM_THREADS" > ~/.steam/steam/steam_dev.cfg
    '';
  };
}
