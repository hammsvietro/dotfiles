{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  services.printing.enable = true;
  services.flatpak.enable = true;
  services.tumbler.enable = true;
  services.gvfs.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];

    config = {
      common = {
        default = [
          "hyprland"
          "gtk"
        ];
      };
    };
  };

  environment.sessionVariables = {
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_CACHE_HOME = "$HOME/.cache";
    SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
  };

  environment.variables = {
    XMODIFIERS = "@im=none";
    GTK_IM_MODULE = "";
    QT_IM_MODULE = "";
  };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  services.usbmuxd.enable = true;

  services.envfs.enable = true;
  services.dbus.enable = true;

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-qt;
  };
  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin
      thunar-volman
    ];
  };
  services.openssh.enable = true;
  environment.shellInit = ''
    gpg-connect-agent /bye
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  '';

  system.stateVersion = "24.11";
}
