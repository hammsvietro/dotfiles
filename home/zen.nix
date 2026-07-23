{ config, lib, ... }:

let
  glassCss = "${config.home.homeDirectory}/dotfiles/home/zen/userChrome-glass.css";
  importLine = ''@import "${glassCss}";'';
in
{
  home.activation.zenGlassChrome = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    for dir in \
      "${config.home.homeDirectory}"/.config/zen/*/chrome \
      "${config.home.homeDirectory}"/.zen/*/chrome; do
      [ -d "$dir" ] || continue
      file="$dir/userChrome.css"
      touch "$file"
      grep -qF '${importLine}' "$file" || printf '%s\n' '${importLine}' >> "$file"
    done
  '';
}
