{
  config,
  pkgs,
  inputs,
  ...
}:

let
  noctalia = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (old: {
    postFixup = (old.postFixup or "") + ''
      substituteInPlace $out/share/noctalia-shell/Modules/Bar/Widgets/Workspace.qml \
        --replace-fail \
          '        if (hideUnoccupied && !ws.isOccupied && !ws.isFocused)' \
          '        if (ws.name === "special")
          continue;
        if (hideUnoccupied && !ws.isOccupied && !ws.isFocused)'
    '';
  });
in
{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.variables = {
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    LIBVA_DRIVER_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };

  environment.systemPackages = with pkgs; [
    swaynotificationcenter
    hypridle
    hyprlock
    hyprshade
    glslviewer
    copyq
    grim
    grimblast
    wlr-randr
    networkmanagerapplet
    hyprpolkitagent

    noctalia
    pywalfox-native
  ];
}
