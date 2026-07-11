{ config, pkgs, ... }:
{
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    useOSProber = true;
    default = "saved";
    theme = pkgs.callPackage ./grub-theme { };
    splashImage = null;
    gfxmodeEfi = "1920x1080";
    gfxmodeBios = "1920x1080";
  };
  boot.supportedFilesystems = [ "ntfs" ];

  boot.loader.timeout = 15;
  boot.loader.efi.canTouchEfiVariables = true;
}
