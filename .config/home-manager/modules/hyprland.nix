{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    swaynotificationcenter
    hypridle
    hyprlock
    copyq
    grim
    grimblast
    wlr-randr
  ];

}
