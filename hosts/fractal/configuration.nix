{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    useOSProber = true;
    default = "saved";
  };
  boot.loader.timeout = 15;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "fractal";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Sao_Paulo";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  users.users.hammsvietro = {
    isNormalUser = true;
    description = "Pedro Hamms Vietro";
    shell = pkgs.bash;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    packages = with pkgs; [ kdePackages.kate ];
  };

  programs.firefox.enable = true;
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    emacs
    ripgrep
    coreutils
    fd
    home-manager
    os-prober
    psmisc
    bash
    docker
    waybar
    hyprpaper
    wofi
    mako
    kitty
    dunst
    desktop-file-utils
    ntfs3g
    anydesk
    tree
    gnupg
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
    tig
  ];

  environment.sessionVariables = {
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/var/lib";
    XDG_CACHE_HOME = "$HOME/var/cache";
    LIBVA_DRIVER_NAME = "nvidia";
  };

  programs.hyprland.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-qt;
  };
  services.envfs.enable = true;
  services.dbus.enable = true;
  virtualisation.docker.enable = true;

  environment.variables = {
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    LIBVA_DRIVER_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };

  nix.settings.experimental-features = [ "nix-command" ];
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [ ruff ];

  system.stateVersion = "24.11";

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      vulkan-loader
      vulkan-validation-layers
      libvdpau
      nvidia-vaapi-driver
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      vulkan-loader
      libvdpau
    ];
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    open = false;
    nvidiaSettings = true;
  };

  nix.extraOptions = ''
    trusted-users = root hammsvietro
  '';

  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 1h";
  };

  nix.optimise = {
    automatic = true;
    dates = [ "weekly" ];
  };
}
