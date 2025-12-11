{ config, pkgs, ... }:

{
  programs.hyprland.enable = true;
  # environment.variables = {
  #   __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  #   GBM_BACKEND = "nvidia-drm";
  #   LIBVA_DRIVER_NAME = "nvidia";
  #   WLR_NO_HARDWARE_CURSORS = "1";
  #   NIXOS_OZONE_WL = "1";
  # };
}
