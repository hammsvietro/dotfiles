{
  imports = [
    ./system/boot.nix
    ./system/nix.nix
    ./system/locale.nix
    ./system/core.nix
    ./system/performance.nix

    ./desktop/hyprland.nix
    ./desktop/plasma.nix
    ./desktop/fonts.nix

    ./hardware/audio.nix

    ./services/maestral.nix

    ./programs/apps.nix
    ./programs/dev.nix
    ./programs/games.nix

    ./users/hammsvietro.nix
  ];
}
