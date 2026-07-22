{
  imports = [
    ./system/boot.nix
    ./system/nix.nix
    ./system/locale.nix
    ./system/core.nix
    ./system/performance.nix
    ./system/overlays.nix

    ./desktop/hyprland.nix
    ./desktop/niri.nix
    ./desktop/display-manager.nix
    ./desktop/fonts.nix
    ./desktop/theming.nix

    ./hardware/audio.nix
    ./hardware/suspend.nix

    ./services/maestral.nix

    ./programs/apps.nix
    ./programs/dev.nix
    ./programs/games.nix

    ./users/hammsvietro.nix
  ];
}
