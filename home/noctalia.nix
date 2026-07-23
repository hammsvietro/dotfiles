{ config, pkgs, ... }:

let
  glass = import ./glass.nix;
  n = glass.noctalia;

  settingsPath = "${config.home.homeDirectory}/dotfiles/home/noctalia/settings.json";

  glassApply = pkgs.writeShellApplication {
    name = "glass-apply";
    runtimeInputs = [ pkgs.gnused ];
    text = ''
      f="${settingsPath}"
      if [ ! -f "$f" ]; then
        echo "glass-apply: $f not found" >&2
        exit 1
      fi

      sed -i \
        -e 's/"backgroundOpacity": [0-9.]*/"backgroundOpacity": ${n.panelOpacity}/g' \
        -e 's/"panelBackgroundOpacity": [0-9.]*/"panelBackgroundOpacity": ${n.panelOpacity}/g' \
        -e 's/"dimmerOpacity": [0-9.]*/"dimmerOpacity": ${n.dimmerOpacity}/g' \
        -e 's/"lockScreenBlur": [0-9.]*/"lockScreenBlur": ${n.lockScreenBlur}/g' \
        -e 's/"overviewBlur": [0-9.]*/"overviewBlur": ${n.overviewBlur}/g' \
        -e 's/"overviewTint": [0-9.]*/"overviewTint": ${n.overviewTint}/g' \
        -e 's/"enableBlurBehind": [a-z]*/"enableBlurBehind": ${n.enableBlurBehind}/g' \
        -e 's/"enableShadows": [a-z]*/"enableShadows": ${n.enableShadows}/g' \
        "$f"

      echo "glass-apply: patched $f (restart noctalia-shell if it does not hot-reload)"
    '';
  };
in
{
  home.packages = [ glassApply ];

  xdg.configFile."noctalia/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home/noctalia/settings.json";

  xdg.configFile."noctalia/fractal-logo.svg".source = ./noctalia/fractal-logo.svg;
}
