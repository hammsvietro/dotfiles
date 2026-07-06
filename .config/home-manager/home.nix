{ pkgs, config, ... }:

let
  emacsUpgradeScript = ''
    pkill -f "emacs --daemon" || true
    "${config.home.homeDirectory}/.config/emacs/bin/doom" upgrade -!
    "${config.home.homeDirectory}/.config/emacs/bin/doom" sync
    emacs --daemon
  '';
in
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
    (writeShellScriptBin "emacs-upgrade" emacsUpgradeScript)
    (writeShellScriptBin "upgrade-emacs" emacsUpgradeScript)
  ];
}
