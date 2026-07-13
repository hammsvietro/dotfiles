{
  imports = [
    ./system/boot.nix
    ./system/nix.nix
    ./system/locale.nix
    ./system/core.nix
    ./system/performance.nix
    ./system/overlays.nix

    ./desktop/hyprland.nix
    ./desktop/plasma.nix
    ./desktop/fonts.nix
    ./desktop/theming.nix

    ./hardware/audio.nix

    ./services/maestral.nix

    ./programs/apps.nix
    ./programs/dev.nix
    ./programs/games.nix
    ./programs/audio-production.nix

    ./users/hammsvietro.nix
  ];
}
