{ config, ... }:

{
  xdg.configFile."qt6ct/qt6ct.conf".text = ''
    [Appearance]
    custom_palette=true
    color_scheme_path=${config.home.homeDirectory}/.config/qt6ct/colors/noctalia.conf
    style=Fusion
    icon_theme=Papirus-Dark
  '';
}
