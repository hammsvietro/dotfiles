{ config, pkgs, ... }:
let
  # PipeWire's JACK shim (provides pw-jack + a replacement libjack).
  pipewireJack = config.services.pipewire.package.jack;

  # On NixOS, `services.pipewire.jack.enable` lets PipeWire ACT as a JACK server,
  # but it does NOT put the client-side libjack / pw-jack on PATH. A JACK-only app
  # like guitarix then loads its own bundled libjack, finds no running jackd, and
  # segfaults on startup. Wrap guitarix so it always launches through pw-jack ->
  # PipeWire, from both the terminal and the app launcher. Truly plug-and-play.
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
    # DAW
    reaper

    # Plug-and-play jam hosts
    guitarix-pw  # guitarix pre-wired to PipeWire's JACK (see wrapper above)
    pipewireJack # `pw-jack <app>` to run any other JACK-only app via PipeWire
    carla        # LV2/VST rack host for building custom pedalboards (savable presets)

    # Amp simulation
    neural-amp-modeler-lv2 # NAM: load real high-gain amp captures (.nam)
    gxplugins-lv2          # Guitarix pedals: tube screamer, boosts, etc.

    # Cabinet impulse-response loader
    ir-lv2 # convolution cab loader (.wav IRs)

    # Noise gate / dynamics / EQ (a tight gate is essential for high-gain djent)
    lsp-plugins
    zam-plugins

    # Reverb / delay / ambient
    dragonfly-reverb
    calf
    x42-plugins # also includes a tuner and meters
    tap-plugins
    airwindows-lv2
    infamousplugins
  ];

  # Plugin discovery paths. nixpkgs installs plugins under
  # /run/current-system/sw/lib/..., which Reaper/Carla do NOT scan by default.
  # User dirs are prepended so hand-installed plugins/NAM models still work.
  environment.sessionVariables = {
    LV2_PATH = "$HOME/.lv2:/run/current-system/sw/lib/lv2";
    VST3_PATH = "$HOME/.vst3:/run/current-system/sw/lib/vst3";
    CLAP_PATH = "$HOME/.clap:/run/current-system/sw/lib/clap";
    LADSPA_PATH = "$HOME/.ladspa:/run/current-system/sw/lib/ladspa";
  };

  # Realtime scheduling headroom for the @audio group (user is already a member).
  security.pam.loginLimits = [
    { domain = "@audio"; item = "rtprio"; type = "-"; value = "95"; }
    { domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited"; }
    { domain = "@audio"; item = "nice"; type = "-"; value = "-19"; }
  ];
}
