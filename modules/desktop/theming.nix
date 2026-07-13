{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    qt6Packages.qt6ct
    adw-gtk3
  ];

  environment.sessionVariables = {
    GTK_THEME = "adw-gtk3-dark";
    QT_QPA_PLATFORMTHEME = "qt6ct";
    QT_PLUGIN_PATH = "${pkgs.qt6Packages.qt6ct}/lib/qt-6/plugins";
  };
}
