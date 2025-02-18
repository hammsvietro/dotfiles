{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [ spotify obsidian stremio discord ];
}
