{
  config,
  pkgs,
  lib,
  ...
}:

{
  fonts.packages =
    with pkgs;
    [
      julia-mono
      jetbrains-mono
    ]
    ++ builtins.filter lib.isDerivation (builtins.attrValues pkgs.nerd-fonts);
}
