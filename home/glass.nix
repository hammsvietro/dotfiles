rec {
  niri = {
    blur = {
      passes = "5";
      offset = "5";
      noise = "0.02";
      saturation = "1.5";
    };
    liquidGlass = {
      refractionStrength = "2.4";
      powerFactor = "5";
      refractionPower = "1.2";
      glowWeight = "0.0001";
      edgeLighting = "1.6";
      edgeThickness = "0.35";
      edgePadding = "0.0";
      saturation = "1.0";
      vibrancy = "0.35";
      brightness = "1.0";
      contrast = "1.05";
      adaptiveDim = "0.2";
      adaptiveBoost = "0.2";
      physicalRefraction = "0.8";
      lensDistortion = "0.9";
      fringing = "0.7";
      refractionDilute = "0.5";
      diluteStrength = "0.6";
      diluteFringing = "0.8";
    };
    # Panels override the window glass: strong blur but near-zero refraction/distortion/fringing,
    # so small bar text stays crisp instead of warping. Merged over liquidGlass in niri.nix.
    panelGlass = {
      refractionStrength = "0.4";
      refractionPower = "1.0";
      physicalRefraction = "0.0";
      lensDistortion = "0.0";
      fringing = "0.0";
      diluteFringing = "0.0";
      edgeLighting = "0.8";
    };
    shadow = {
      softness = "30";
      spread = "4";
      offsetX = "0";
      offsetY = "5";
      color = "#00000055";
    };
    focusRing = {
      activeFrom = "#33ccffee";
      activeTo = "#00ff99ee";
      inactiveColor = "#59595955";
    };
  };

  # Per-app background transparency. Each app draws its own background with alpha so text
  # stays crisp; niri renders the shared blur + liquid-glass backdrop behind it. Values are
  # in the app's own unit:
  #   backgroundOpacity — the app's own background alpha, 0..1
  #   alphaBackground   — emacs frame background alpha, 0..100
  #   tint              — nemo frosted-scrim alpha applied via GTK css, 0..1
  apps = {
    ghostty.backgroundOpacity = "0.10";
    emacs.alphaBackground = "65";
    nemo.tint = "0.30";
  };

  noctalia = {
    panelOpacity = "0.28";
    dimmerOpacity = "0.2";
    enableBlurBehind = "true";
    enableShadows = "true";
    lockScreenBlur = "0";
    overviewBlur = "0.4";
    overviewTint = "0.6";
  };
}
