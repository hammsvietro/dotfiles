{ config, pkgs, ... }:

{

  home.packages = with pkgs; [
    steam # Steam client
    steamcmd # Steam CLI (optional)
    gamemode # Game optimization tool
    vkbasalt # Vulkan post-processing effects
    protontricks # Manage Proton dependencies
    libstrangle # FPS limiter
    goverlay # GUI for MangoHud, vkBasalt, etc.
    fuse2
  ];

  # NVIDIA and Steam Optimizations
  home.sessionVariables = {
    STEAM_FORCE_DESKTOPUI_SCALING = "1"; # Fix UI scaling
    VKBASALT_CONFIG_FILE = "$HOME/.config/vkBasalt/vkBasalt.conf";
    GAMEMODERUN =
      "${pkgs.gamemode}/bin/gamemoderun"; # Ensure Gamemode is available
  };

  # Create vkBasalt config directory
  xdg.configFile = {
    "vkBasalt/vkBasalt.conf" = {
      text = ''
        effects = fxaa
      '';
    };
  };

}
