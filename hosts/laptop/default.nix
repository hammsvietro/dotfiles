{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules
    ../../modules/hardware/nvidia-laptop.nix
  ];

  networking.hostName = "hammsvietro-laptop";
}
