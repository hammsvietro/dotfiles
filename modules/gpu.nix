{ config, pkgs, ... }:

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;

    extraPackages = with pkgs; [
      vulkan-loader
      vulkan-validation-layers
      libvdpau
      nvidia-vaapi-driver
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      vulkan-loader
      libvdpau
    ];
  };

  nixpkgs.config.nvidia.acceptLicense = true;

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.legacy_535;
  };

  services.xserver.videoDrivers = [ "nvidia" ];
}
