{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/base.nix
    ../../modules/apps.nix
    ../../modules/audio.nix
    ../../modules/boot.nix
    ../../modules/laptop-gpu.nix
    ../../modules/desktop/plasma.nix
    ../../modules/desktop/hyprland.nix
    ../../modules/users/hammsvietro.nix
  ];

  networking.hostName = "hammsvietro-laptop";

}
