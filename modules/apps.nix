{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gnome-tweaks
    neovim
    zed-editor
    wget
    git
    emacs
    jemalloc
    openssl
    pkg-config
    ripgrep
    coreutils
    alacritty
    fd
    home-manager
    os-prober
    psmisc
    bash
    docker
    waybar
    hyprpaper
    wofi
    mako
    dunst
    desktop-file-utils
    ntfs3g
    anydesk
    tree
    gnupg
    pavucontrol
    ffmpeg
    wl-clipboard
    zip
    unzip
    pciutils
    tig
    firefox-bin
    libva-utils
    rustup
    qpwgraph
  ];
  programs.kdeconnect.enable = true;

}
