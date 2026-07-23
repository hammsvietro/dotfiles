{ pkgs, inputs, ... }:

{
  programs.niri.enable = true;
  programs.niri.package = inputs.niri-glass.packages.${pkgs.stdenv.hostPlatform.system}.default;

  environment.systemPackages = with pkgs; [
    xwayland-satellite
  ];
}
