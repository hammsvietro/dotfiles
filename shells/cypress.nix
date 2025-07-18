{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  buildInputs = with pkgs; [ nodejs_22 steam-run nss nspr ];

  shellHook = ''
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${pkgs.nss}/lib:${pkgs.nspr}/lib"
  '';

  packages = [
    (pkgs.writeShellScriptBin "run-cypress" ''
      set -e

      steam-run npx cypress open
    '')
  ];
}
