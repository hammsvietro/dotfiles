{ config, pkgs, ... }:

{
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

      # Use the work Claude account under ~/work (recursively), personal elsewhere.
      # CLAUDE_CONFIG_DIR isolates auth, settings and project history per account.
      claude() {
        case "$PWD/" in
          "$HOME/work/"*)
            CLAUDE_CONFIG_DIR="$HOME/.config/claude-work" command claude "$@"
            ;;
          *)
            command claude "$@"
            ;;
        esac
      }
    '';
  };

  programs.starship.enable = true;

  home.sessionPath = [
    "${config.home.homeDirectory}/.cargo/bin"
  ];

  home.sessionVariables = {
    CARGO_PROFILE_DEV_BUILD_OVERRIDE_DEBUG = "true";
  };
}
