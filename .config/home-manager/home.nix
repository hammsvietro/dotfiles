{ config, pkgs, ... }:

{

  home.stateVersion = "24.11";
  home.username = "hammsvietro";
  home.homeDirectory = "/home/hammsvietro";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    fastfetch
    htop
    tmux
  ];

  programs.zsh.enable = true;
  programs.starship.enable = true;

  home.sessionPath = [
    "$HOME/.cargo/bin"
  ];
  home.sessionVariables = {
    CARGO_PROFILE_DEV_BUILD_OVERRIDE_DEBUG = "true";
  };

  programs.bash = {
    enable = true;
    bashrcExtra = ''
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
    settings = {
      user = {
        name = "Pedro Vietro";
        email = "hammsvietro@gmail.com";
      };
      gpg = {
        format = "ssh";
      };
    };
    signing = {
      signByDefault = true;
      key = "~/.ssh/id_rsa.pub";
    };

  };

  xdg.configFile = {
    "nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/nvim";
      recursive = true;
    };
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
