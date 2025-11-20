{ config, pkgs, ... }:

{

  imports = [
    (builtins.path { path = ./modules/dev-tools.nix; })
    (builtins.path { path = ./modules/apps.nix; })
    (builtins.path { path = ./modules/hyprland.nix; })
    (builtins.path { path = ./modules/games.nix; })
  ];

  home.stateVersion = "24.11";
  home.username = "hammsvietro";
  home.homeDirectory = "/home/hammsvietro";
  programs.home-manager.enable = true;

  # Install packages
  home.packages =
    with pkgs;
    [
      neofetch
      htop
      tmux
      fd
      ripgrep
      gnutls
      bash
    ]
    ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
  nixpkgs.config.allowUnfree = true;
  fonts.fontconfig.enable = true;

  programs.zsh.enable = false; # Disable Zsh
  programs.bash = {
    enable = true; # Enable Bash
    bashrcExtra = ''
      # Source your custom bashrc
      if [ -f ~/.secrets.sh ]; then
        source ~/.secrets.sh
      fi
      if [ -f ~/dotfiles.bashrc ]; then
        source ~/dotfiles.bashrc
      fi
    '';
  };

  programs.git = {
    enable = true;
    userName = "Pedro Vietro";
    userEmail = "hammsvietro@gmail.com";
    signing = {
      signByDefault = true;
      key = "~/.ssh/id_rsa.pub";
    };

    extraConfig = {
      gpg.format = "ssh";
    };
  };

  xdg.configFile = {
    "doom" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/doom";
      recursive = true;
    };
    "hypr" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/hypr";
      recursive = true;
    };
    "waybar" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/waybar";
      recursive = true;
    };
  };

  home.file = {
    "shells" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/shells";
      recursive = true;
    };
    "wallpapers" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/wallpapers";
      recursive = true;
    };
    ".tmux.conf" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.tmux.conf";
    };
  };
}
