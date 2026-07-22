{ config, pkgs, ... }:
{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;

    extraPackages = with pkgs; [
      vulkan-loader
      vulkan-validation-layers
      vulkan-tools
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
    powerManagement.enable = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  services.lact.enable = true;

  environment.variables = {
    __GL_SYNC_TO_VBLANK = "0";
  };

  environment.sessionVariables = {
    VK_LOADER_DRIVERS_SELECT = "nvidia_icd.json";
  };
}
