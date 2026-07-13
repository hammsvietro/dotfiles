{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    zed-editor
    nixd
  ];

  xdg.configFile."zed".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home/zed";
}
