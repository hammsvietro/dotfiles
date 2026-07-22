{ pkgs, config, ... }:

let
  emacsUpgradeScript = ''
    pkill -f "emacs --daemon" || true
    "${config.home.homeDirectory}/.config/emacs/bin/doom" upgrade -!
    "${config.home.homeDirectory}/.config/emacs/bin/doom" sync
    emacs --daemon
  '';
  emacsUpgrade = pkgs.writeShellScriptBin "emacs-upgrade" emacsUpgradeScript;
in
{
  imports = [
    ./hyprland.nix
    ./niri.nix
    ./shell.nix
    ./git.nix
    ./terminal.nix
    ./zed.nix
    ./noctalia.nix
    ./greeter.nix
    ./files.nix
    ./theming.nix
    ./blackwall.nix
    ./secrets.nix
    ./mime.nix
  ];

  home.stateVersion = "24.11";
  home.username = "hammsvietro";
  home.homeDirectory = "/home/hammsvietro";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    fastfetch
    btop
    tmux
    emacsUpgrade
    (runCommand "upgrade-emacs" { } ''
      mkdir -p $out/bin
      ln -s ${emacsUpgrade}/bin/emacs-upgrade $out/bin/upgrade-emacs
    '')
  ];
}
