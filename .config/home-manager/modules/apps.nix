{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    spotify
    discord
    notion-app-enhanced
    pavucontrol
    insomnia
    ffmpeg
    vlc
    wl-clipboard
    thunderbird
    zip
    unzip
    kitty
    pciutils
    qbittorrent

    (google-chrome.override {
      commandLineArgs = "--disable-gpu-compositing --enable-features=UseOzonePlatform --ozone-platform=wayland";
    })

    (obsidian.overrideAttrs (old: {
      postFixup = (old.postFixup or "") + ''
        wrapProgram $out/bin/obsidian \
          --set NIXOS_OZONE_WL 1 \
          --add-flags "--disable-gpu-compositing --enable-features=UseOzonePlatform --ozone-platform=wayland"
      '';
    }))
  ];
}
