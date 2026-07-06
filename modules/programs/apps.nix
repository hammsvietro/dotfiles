{
  config,
  pkgs,
  inputs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    emacs-pgtk
    vim

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
    gnupg
    zsh

    wofi
    desktop-file-utils
    wl-clipboard
    imagemagick

    teams-for-linux

    dunst

    ffmpeg
    vlc
    pavucontrol
    qpwgraph

    maestral
    maestral-gui

    spotify
    thunderbird
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    qbittorrent
    insomnia
    whatsapp-electron

    zip
    unzip
    ntfs3g
    pciutils

    docker
    rustup
    libva-utils
    os-prober
    home-manager

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
    pinentry-qt

    libimobiledevice
    ifuse

    playerctl
  ];
}
