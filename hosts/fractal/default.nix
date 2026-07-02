{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules
    ../../modules/hardware/nvidia-desktop.nix
  ];

  networking.hostName = "fractal";
}
