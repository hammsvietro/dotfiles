{ ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      # 1.4.350.0 defaults UPDATE_DEPS=ON upstream, so CMake tries to git-clone
      # deps at build time; the deps are already in buildInputs, so turn it off.
      vulkan-validation-layers = prev.vulkan-validation-layers.overrideAttrs (old: {
        cmakeFlags = (old.cmakeFlags or [ ]) ++ [ "-DUPDATE_DEPS=OFF" ];
      });
    })
  ];
}
