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
  home.packages = with pkgs; [
    neofetch
    htop
    tmux
    fd
    ripgrep
    gnutls
    bash
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];
  nixpkgs.config.allowUnfree = true;

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
  };

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
    "shells" = {
      source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/dotfiles/shells";
      recursive = true;
    };
    "wallpapers" = {
      source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/dotfiles/wallpapers";
      recursive = true;
    };
    ".tmux.conf" = {
      source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/dotfiles/.tmux.conf";
    };
  };

  home.sessionVariables = {
    OZONE_PLATFORM = "wayland";
    CHROME_USE_GL = "desktop";
    NIXOS_OZONE_WL = "1";
  };
}
