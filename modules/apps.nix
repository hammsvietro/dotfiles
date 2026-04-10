{
  config,
  pkgs,
  inputs,
  ...
}:

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
    gnupg
    zsh

    # Desktop / Wayland
    wofi
    desktop-file-utils
    wl-clipboard

    # Notifications
    dunst

    # Media
    ffmpeg
    vlc
    pavucontrol
    qpwgraph

    maestral
    maestral-gui

    # Apps
    spotify
    thunderbird
    firefox-bin
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
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
    pinentry-qt

    # Mobile
    libimobiledevice
    ifuse
  ];

  systemd.user.services.maestral = {
    description = "Maestral Dropbox Client";

    wantedBy = [ "graphical-session.target" ];

    after = [ "graphical-session.target" ];

    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.maestral}/bin/maestral start -f";
      ExecStop = "${pkgs.maestral}/bin/maestral stop";

      Restart = "on-failure";
      RestartSec = "10s";

      MemoryHigh = "500M";
      MemoryMax = "1G";
    };
  };
}
