{ config, pkgs, ... }:
let
  pipewireJack = config.services.pipewire.package.jack;

  # Wrap guitarix to launch via pw-jack so it connects to PipeWire's JACK
  # instead of its bundled libjack (which segfaults with no running jackd).
  guitarix-pw = pkgs.symlinkJoin {
    name = "guitarix-pipewire";
    paths = [ pkgs.guitarix ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      for prog in $(ls ${pkgs.guitarix}/bin); do
        rm -f "$out/bin/$prog"
        makeWrapper ${pipewireJack}/bin/pw-jack "$out/bin/$prog" \
          --add-flags ${pkgs.guitarix}/bin/"$prog"
      done
    '';
  };
in
{
  environment.systemPackages = with pkgs; [
    reaper

    guitarix-pw
    pipewireJack
    carla

    neural-amp-modeler-lv2
    gxplugins-lv2
    ir-lv2

    lsp-plugins
    zam-plugins

    dragonfly-reverb
    calf
    x42-plugins
    tap-plugins
    airwindows-lv2
    infamousplugins
  ];

  # User dirs first so hand-installed plugins/NAM models are found.
  environment.sessionVariables = {
    LV2_PATH = "$HOME/.lv2:/run/current-system/sw/lib/lv2";
    VST3_PATH = "$HOME/.vst3:/run/current-system/sw/lib/vst3";
    CLAP_PATH = "$HOME/.clap:/run/current-system/sw/lib/clap";
    LADSPA_PATH = "$HOME/.ladspa:/run/current-system/sw/lib/ladspa";
  };

  security.pam.loginLimits = [
    {
      domain = "@audio";
      item = "rtprio";
      type = "-";
      value = "95";
    }
    {
      domain = "@audio";
      item = "memlock";
      type = "-";
      value = "unlimited";
    }
    {
      domain = "@audio";
      item = "nice";
      type = "-";
      value = "-19";
    }
  ];
}
