{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    spotify
    stremio
    discord
    pavucontrol
    uv

    (google-chrome.override {
      commandLineArgs =
        "--disable-gpu-compositing --enable-features=UseOzonePlatform --ozone-platform=wayland";
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
