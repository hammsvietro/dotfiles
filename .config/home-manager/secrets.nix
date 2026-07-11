{ config, lib, ... }:

let
  sopsFile = ../../secrets/construct.yaml;
  # Enumerate the vault's secret names at eval time so every var lands in the
  # rendered env without being named here. Only column-0 `name:` lines are data
  # keys; the indented `sops:` metadata block and blank lines are skipped.
  lines = lib.splitString "\n" (builtins.readFile sopsFile);
  keyLines = builtins.filter (l: builtins.match "[a-zA-Z_][a-zA-Z0-9_]*:.*" l != null) lines;
  keys = builtins.filter (k: k != "sops") (map (l: builtins.head (lib.splitString ":" l)) keyLines);
in
{
  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = sopsFile;
    secrets = lib.genAttrs keys (_: { });
    templates."construct.env".content =
      lib.concatMapStrings (k: "${k}=${config.sops.placeholder.${k}}\n") keys;
  };
}
