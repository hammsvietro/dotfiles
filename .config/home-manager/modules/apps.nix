{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    spotify
    stremio
    discord
    pavucontrol

    # Google Chrome override (using `override` instead of `overrideAttrs`)
    (google-chrome.override {
      commandLineArgs =
        "--enable-features=UseOzonePlatform --ozone-platform=wayland";
    })

    # Obsidian override (using `overrideAttrs`)
    (obsidian.overrideAttrs (old: {
      postFixup = (old.postFixup or "") + ''
        wrapProgram $out/bin/obsidian \
          --set NIXOS_OZONE_WL 1 \
          --add-flags "--disable-gpu-compositing --enable-features=UseOzonePlatform --ozone-platform=wayland"
      '';
    }))
  ];
}
