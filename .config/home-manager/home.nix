{ pkgs, ... }:

{
  imports = [
    ./hyprland.nix
    ./shell.nix
    ./git.nix
    ./terminal.nix
    ./files.nix
    ./mime.nix
  ];

  home.stateVersion = "24.11";
  home.username = "hammsvietro";
  home.homeDirectory = "/home/hammsvietro";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    fastfetch
    htop
    tmux
  ];
}
