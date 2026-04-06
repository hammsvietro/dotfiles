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

    history = {
      path = "${config.xdg.dataHome}/zsh/history";
      ignoreDups = true;
      share = false;
    };

    envExtra = ''
      export PATH="${config.home.homeDirectory}/.cargo/bin:$PATH"
    '';
    initExtra = "";

    initContent = ''
      bindkey "^[[1;5D" backward-word
      bindkey "^[[1;5C" forward-word

      # TODO: Use sops-nix to manage secrets instead of sourcing a separate file
      if [ -f ~/.secrets.sh ]; then
        source ~/.secrets.sh
      fi


      function _set_block_cursor() {
          printf '\e[2 q'
      }

      function zle-line-init zle-keymap-select {
          _set_block_cursor
      }

      zle -N zle-line-init
      zle -N zle-keymap-select

      _set_block_cursor
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

      init.defaultBranch = "main";
      core.editor = "emacsclient -t -a ''";
    };

    signing = {
      format = "ssh";
      signByDefault = true;
      key = "~/.ssh/id_rsa.pub";
    };

  };
  programs.ghostty = {
    enable = true;
    package = pkgs.symlinkJoin {
      name = "ghostty-wrapped";
      paths = [ pkgs.ghostty ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/ghostty \
          --set GTK_IM_MODULE simple
      '';
      meta.mainProgram = "ghostty";
    };

    settings = {
      cursor-style = "block";
      cursor-style-blink = false;
      background-opacity = 0.8;
      shell-integration = "none";

      working-directory = "home";
      window-inherit-working-directory = false;

      tab-inherit-working-directory = true;
      split-inherit-working-directory = true;
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
