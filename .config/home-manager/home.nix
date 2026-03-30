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

  programs.zsh = {
    enable = true;

    envExtra = ''
      export PATH="${config.home.homeDirectory}/.cargo/bin:$PATH"
    '';

    initContent = ''
      # TODO: Use sops-nix to manage secrets instead of sourcing a separate file
           if [ -f ~/.secrets.sh ]; then
             source ~/.secrets.sh
           fi
    '';
  };

  programs.starship.enable = true;

  home.sessionPath = [
    "${config.home.homeDirectory}/.cargo/bin"
  ];

  home.sessionVariables = {
    CARGO_PROFILE_DEV_BUILD_OVERRIDE_DEBUG = "true";
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
      format = null;
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
