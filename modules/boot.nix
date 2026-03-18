{ config, pkgs, ... }:
{
  boot.kernelPackages = pkgs.linuxPackages_zen;

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    useOSProber = true;
    default = "saved";
  };

  boot.loader.timeout = 15;
  boot.loader.efi.canTouchEfiVariables = true;
}
