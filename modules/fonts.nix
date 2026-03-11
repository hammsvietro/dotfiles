{ config, pkgs, ... }:

{
  fonts.packages = with pkgs; [
    julia-mono
    nerd-fonts.zed-mono
    jetbrains-mono
  ];
}
