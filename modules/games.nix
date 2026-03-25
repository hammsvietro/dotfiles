{ config, pkgs, ... }:
{
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    extraPackages = with pkgs; [ gamemode ];
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
      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 0;
        nv_powermizer_mode = 1;
        nv_core_clock_mhz_offset = 100;
        nv_mem_clock_mhz_offset = 200;
      };
      cpu = {
        park_cores = "no";
        pin_cores = "no";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    vkbasalt
    protontricks
    libstrangle
    goverlay
    fuse2
    mangohud
  ];

  environment.sessionVariables = {
    STEAM_FORCE_DESKTOPUI_SCALING = "1";
    STEAM_GAME_FORCE_GAMEMODE = "1";
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

      # Ensure minimum of 4 threads
      if [ $STEAM_THREADS -lt 4 ]; then
        STEAM_THREADS=4
      fi

      mkdir -p ~/.steam/steam
      echo "unShaderBackgroundProcessingThreads $STEAM_THREADS" > ~/.steam/steam/steam_dev.cfg
    '';
  };
}
