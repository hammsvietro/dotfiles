{
  config,
  pkgs,
  lib,
  ...
}:

let
  glass = import ./glass.nix;

  # Neutral frosted scrim scoped to Nemo (.nemo-window); the outer window carries the tint,
  # inner surfaces are transparent so niri's blur + liquid-glass shows through with crisp text.
  # A literal rgba keeps it independent of noctalia's @define-color import order.
  nemoGlassCss = pkgs.writeText "nemo-glass.css" ''
    .nemo-window {
      background-color: rgba(0, 0, 0, ${glass.apps.nemo.tint});
    }

    .nemo-window .nemo-window-pane,
    .nemo-window notebook,
    .nemo-window notebook > stack,
    .nemo-window scrolledwindow,
    .nemo-window .view,
    .nemo-window iconview,
    .nemo-window treeview.view,
    .nemo-window .sidebar,
    .nemo-window placessidebar,
    .nemo-window .primary-toolbar,
    .nemo-window headerbar,
    .nemo-window .statusbar {
      background-color: transparent;
    }
  '';
in
{
  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
  };

  xdg.configFile."qt6ct/qt6ct.conf".text = ''
    [Appearance]
    custom_palette=true
    color_scheme_path=${config.home.homeDirectory}/.config/qt6ct/colors/noctalia.conf
    style=Fusion
    icon_theme=Papirus-Dark
  '';

  # noctalia's gtk-refresh only appends its own import, never truncates, so appending ours
  # is safe both ways. gtk.css must stay a real file (noctalia rewrites a symlinked one).
  home.activation.nemoGlassCss = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    gtkDir="$HOME/.config/gtk-3.0"
    ${pkgs.coreutils}/bin/mkdir -p "$gtkDir"
    ${pkgs.coreutils}/bin/cp --no-preserve=mode --remove-destination "${nemoGlassCss}" "$gtkDir/nemo-glass.css"
    css="$gtkDir/gtk.css"
    ${pkgs.coreutils}/bin/touch "$css"
    if ! ${pkgs.gnugrep}/bin/grep -q "nemo-glass.css" "$css"; then
      printf '\n@import url("nemo-glass.css");\n' >> "$css"
    fi
  '';
}
