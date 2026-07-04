# Out-of-store symlinks stay live-editable without a home-manager rebuild.
{ config, pkgs, lib, ... }:

let
  claudeSettingsFile = pkgs.writeText "claude-settings.json" (builtins.toJSON {
    statusLine = {
      type = "command";
      command = "~/.claude/statusline.sh";
    };
    enabledPlugins = {
      "rust-analyzer-lsp@claude-plugins-official" = true;
      "pyright-lsp@claude-plugins-official" = true;
    };
    effortLevel = "high";
    theme = "dark";
    model = "opusplan";
  });
  claudeWorkSettingsFile = pkgs.writeText "claude-work-settings.json" (builtins.toJSON {
    statusLine = {
      type = "command";
      command = "~/.config/claude-work/statusline.sh";
    };
    enabledPlugins = {
      "pyright-lsp@claude-plugins-official" = true;
      "typescript-lsp@claude-plugins-official" = true;
    };
    effortLevel = "medium";
    theme = "dark";
    model = "opusplan";
  });
in
{
  xdg.configFile = {
    "doom" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/doom";
      recursive = true;
    };
  };

  home.file = {
    "org" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Dropbox/org";
      recursive = true;
    };
    "wallpapers" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/wallpapers";
      recursive = true;
    };
    ".claude/statusline.sh" = {
      source = ./statusline.sh;
      executable = true;
    };
    ".config/claude-work/statusline.sh" = {
      source = ./statusline.sh;
      executable = true;
    };

    ".tmux.conf".text = ''
      set -g base-index 1
      setw -g pane-base-index 1
      set -g mouse on
      set -g terminal-overrides 'xterm*:smcup@:rmcup@'
      set -g default-terminal "tmux-256color"
      set -ag terminal-overrides ",xterm-256color:RGB"

      set-option -g status-style fg=colour136,bg=colour235

      set -sg escape-time 20

      bind '"' split-window -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"


      set-option -g status-position top
      set-option -g status-right-length 140
      set-option -g status-right-style default
      set-option -g status-right "#[fg=green,bg=default,bright]#(tmux-mem-cpu-load -a 0)"
      set-option -ag status-right " #[fg=default,bg=default]%a %l:%M:%S %p#[default] #[fg=blue]%Y-%m-%d #[fg=default]#H "
      set-window-option -g window-status-style fg=colour244
      set-window-option -g window-status-style bg=default
      set-window-option -g window-status-current-style fg=colour166
      set-window-option -g window-status-current-style bg=default
      set-option -g history-limit 50000


      set -Fg 'status-format[1]' '#{status-format[0]}'
      set -g 'status-format[0]' '''
      set -g status 2
    '';
  };

  home.activation.claudeSettingsWritable = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${pkgs.coreutils}/bin/mkdir -p "$HOME/.claude"
    ${pkgs.coreutils}/bin/cp --no-preserve=mode --remove-destination "${claudeSettingsFile}" "$HOME/.claude/settings.json"
    ${pkgs.coreutils}/bin/mkdir -p "$HOME/.config/claude-work"
    ${pkgs.coreutils}/bin/cp --no-preserve=mode --remove-destination "${claudeWorkSettingsFile}" "$HOME/.config/claude-work/settings.json"
  '';
}
