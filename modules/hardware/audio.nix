{ config, pkgs, ... }:

{
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
    extraConfig.pipewire."92-low-latency" = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        # Default quantum left at 1024 so everyday desktop audio is unchanged.
        # Only the floor is lowered so DAWs/guitar hosts can opt into low latency.
        "default.clock.quantum" = 1024;
        "default.clock.min-quantum" = 64;
      };
    };
  };
}
