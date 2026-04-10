{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/base.nix
    ../../modules/apps.nix
    ../../modules/audio.nix
    ../../modules/laptop-gpu.nix
    ../../modules/boot.nix
    ../../modules/fonts.nix
    ../../modules/dev.nix
    ../../modules/games.nix
    ../../modules/services.nix
    ../../modules/performance.nix
    ../../modules/desktop/plasma.nix
    ../../modules/desktop/hyprland.nix
    ../../modules/users/hammsvietro.nix
  ];

  networking.hostName = "hammsvietro-laptop";
}
