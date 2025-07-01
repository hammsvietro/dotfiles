{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules =
    [ "kvm-intel" "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
  boot.extraModulePackages = [ ];
  boot.extraModprobeConfig = ''
    options nvidia_drm modeset=1
  '';

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/6b08b4d6-4006-40d7-bb17-16385e62db08";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."luks-4457eb78-5bb3-49d1-894f-cb0630850787".device =
    "/dev/disk/by-uuid/4457eb78-5bb3-49d1-894f-cb0630850787";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/02C1-C3D0";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };

  swapDevices = [ ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}
