{ config, pkgs, ... }:

{
  imports = [ ./gpu.nix ];

  hardware.nvidia = {
    powerManagement.enable = true;
    powerManagement.finegrained = false;
  };
}
