{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "nvme"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/a819dd7d-8530-4217-9fce-ede883ecf7e3";
    fsType = "ext4";
    options = [ "noatime" ];
  };

  boot.initrd.luks.devices."luks-c66cd5d7-0de9-4be0-ab26-d858cd91bd00".device =
    "/dev/disk/by-uuid/c66cd5d7-0de9-4be0-ab26-d858cd91bd00";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/3995-44C0";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/44a5f86b-880d-4d33-b854-bf2052680598"; }
  ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
