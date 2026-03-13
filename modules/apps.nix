{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Editors
    emacs-pgtk
    vim

    # Core CLI
    wget
    git
    ripgrep
    coreutils
    fd
    tree
    jq
    tig
    lsof
    gnumake
    psmisc
    bash
    gnupg

    # Terminal emulators
    alacritty
    kitty

    # Desktop / Wayland
    waybar
    hyprpaper
    wofi
    desktop-file-utils
    wl-clipboard

    # Notifications (pick one — you have both mako AND dunst)
    dunst

    # Media
    ffmpeg
    vlc
    pavucontrol
    qpwgraph

    # Apps
    spotify
    thunderbird
    firefox-bin
    qbittorrent
    insomnia
    anydesk
    whatsapp-electron

    # Archive / filesystem
    zip
    unzip
    ntfs3g
    pciutils

    # Dev infra
    docker
    rustup
    libva-utils
    os-prober
    home-manager

    # Wayland-native Electron apps
    (google-chrome.override {
      commandLineArgs = "--enable-features=UseOzonePlatform --ozone-platform=wayland";
    })

    (obsidian.overrideAttrs (old: {
      postFixup = (old.postFixup or "") + ''
        wrapProgram $out/bin/obsidian \
          --set NIXOS_OZONE_WL 1 \
          --add-flags "--enable-features=UseOzonePlatform --ozone-platform=wayland"
      '';
    }))

    notion-app-enhanced
  ];
}
