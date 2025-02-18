{ config, pkgs, ... }:

{

  imports = [
    (builtins.path { path = ./modules/dev-tools.nix; })
    (builtins.path { path = ./modules/apps.nix; })
  ];

  home.stateVersion = "24.11";
  home.username = "hammsvietro";
  home.homeDirectory = "/home/hammsvietro";
  programs.home-manager.enable = true;

  # Install packages
  home.packages = with pkgs; [
    neofetch
    htop
    tmux
    alacritty
    fd
    ripgrep
    gnutls

    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];
  nixpkgs.config.allowUnfree = true;

  programs.git = {
    enable = true;
    userName = "Pedro Vietro";
    userEmail = "hammsvietro@gmail.com";
  };

  programs.zsh.enable = true;

  xdg.configFile = {
    "doom" = {
      source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/dotfiles/.config/doom";
      recursive = true;
    };
    "hypr" = {
      source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/dotfiles/.config/hypr";
      recursive = true;
    };
    "waybar" = {
      source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/dotfiles/.config/waybar";
      recursive = true;
    };
    "kitty" = {
      source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/dotfiles/.config/kitty";
      recursive = true;
    };
  };

  home.file = {
    "wallpapers" = {
      source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/dotfiles/wallpapers";
      recursive = true;
    };
  };
}
