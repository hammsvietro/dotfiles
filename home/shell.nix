{ config, ... }:

{
  programs.fish = {
    enable = true;

    shellAbbrs = {
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git pull";
      gd = "git diff";
      gco = "git checkout";
      gb = "git branch";
    };

    interactiveShellInit = ''
      set -g fish_greeting

      printf '\e[2 q'

      if test -r ${config.sops.templates."construct.env".path}
        for line in (cat ${config.sops.templates."construct.env".path})
          set -l kv (string split -m1 = -- $line)
          test -n "$kv[1]"; and set -gx $kv[1] $kv[2]
        end
      end
    '';

    functions = {
      source = ''
        if test (count $argv) -ge 1
          set -l target $argv[1]
          if string match -qr '(^|/)activate$' -- $target; and test -f "$target.fish"
            set argv[1] "$target.fish"
          end
        end
        builtin source $argv
      '';

      claude = ''
        switch $PWD/
          case "$HOME/work/*"
            env CLAUDE_CONFIG_DIR="$HOME/.config/claude-work" claude $argv
          case '*'
            command claude $argv
        end
      '';

      pclaude = ''
        env CLAUDE_CONFIG_DIR="$HOME/.claude" claude $argv
      '';
    };
  };

  programs.eza = {
    enable = true;
    enableFishIntegration = true;
    icons = "auto";
    git = true;
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "OneHalfDark";
      pager = "less -FR";
    };
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    options = [ "--cmd cd" ];
  };

  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      auto_sync = false;
      search_mode = "fuzzy";
      style = "compact";
      inline_height = 20;
      show_preview = true;
      enter_accept = true;
    };
  };

  programs.starship = {
    enable = true;

    settings = {
      add_newline = true;
      command_timeout = 1000;

      palette = "one_dark";
      palettes.one_dark = {
        blue = "#61afef";
        mauve = "#c678dd";
        green = "#98c379";
        red = "#e06c75";
        yellow = "#e5c07b";
        peach = "#d19a66";
        cyan = "#56b6c2";
        text = "#abb2bf";
        subtext = "#5c6370";
      };

      format = "$os$username$hostname$directory$git_branch$git_status$nix_shell$nodejs$python$rust$golang$docker_context$fill$cmd_duration$battery$time\n$character";

      os.disabled = true;

      username = {
        show_always = false;
        style_user = "fg:text";
        format = "[$user]($style) ";
      };

      hostname = {
        ssh_only = true;
        style = "fg:red";
        format = "on [$hostname]($style) ";
      };

      directory = {
        style = "bold fg:blue";
        format = "[ $path]($style)[$read_only]($read_only_style) ";
        truncation_length = 3;
        truncate_to_repo = true;
        read_only = " 󰌾";
        read_only_style = "fg:red";
      };

      git_branch = {
        symbol = " ";
        style = "bold fg:mauve";
        format = "[on ](fg:subtext)[$symbol$branch]($style) ";
      };

      git_status = {
        style = "fg:yellow";
        format = "([$all_status$ahead_behind]($style)) ";
      };

      nix_shell = {
        symbol = " ";
        style = "bold fg:cyan";
        format = "[$symbol$state]($style) ";
      };

      nodejs = {
        symbol = " ";
        style = "fg:green";
        format = "[$symbol$version]($style) ";
      };

      python = {
        symbol = " ";
        style = "fg:yellow";
        format = "[$symbol$version]($style) ";
      };

      rust = {
        symbol = " ";
        style = "fg:peach";
        format = "[$symbol$version]($style) ";
      };

      golang = {
        symbol = " ";
        style = "fg:cyan";
        format = "[$symbol$version]($style) ";
      };

      docker_context = {
        symbol = " ";
        style = "fg:blue";
        format = "[$symbol$context]($style) ";
        only_with_files = true;
      };

      fill.symbol = " ";

      cmd_duration = {
        min_time = 2000;
        style = "fg:subtext";
        format = "took [$duration]($style) ";
      };

      battery = {
        full_symbol = "🔋";
        charging_symbol = "🔌";
        discharging_symbol = "⚡";
        display = [
          {
            threshold = 30;
            style = "fg:red";
          }
        ];
      };

      time = {
        disabled = false;
        style = "fg:subtext";
        format = "[$time]($style)";
        time_format = "%H:%M";
      };

      character = {
        success_symbol = "[❯](bold fg:green)";
        error_symbol = "[❯](bold fg:red)";
        vimcmd_symbol = "[❮](bold fg:yellow)";
      };
    };
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.cargo/bin"
    "${config.home.homeDirectory}/.config/emacs/bin"
  ];

  home.sessionVariables = {
    CARGO_PROFILE_DEV_BUILD_OVERRIDE_DEBUG = "true";
    ANTHROPIC_MODEL = "opusplan";
  };
}
