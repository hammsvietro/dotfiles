{ config, pkgs, ... }:

{
  time.timeZone = "America/Sao_Paulo";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocales = [ "pt_BR.UTF-8/UTF-8" ];
}
