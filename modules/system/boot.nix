{ config, pkgs, ... }:
{
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    useOSProber = true;
    default = "saved";
  };
  boot.supportedFilesystems = [ "ntfs" ];

  boot.loader.timeout = 15;
  boot.loader.efi.canTouchEfiVariables = true;
}
