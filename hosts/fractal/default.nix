{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules
    ../../modules/hardware/nvidia-desktop.nix
    ../../modules/programs/audio-production.nix
  ];

  networking.hostName = "fractal";
}
