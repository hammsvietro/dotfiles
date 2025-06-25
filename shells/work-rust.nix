with import <nixpkgs> { };

pkgs.mkShell {
  buildInputs = [ ];

  shellHook = ''
    export CFLAGS="-O2 -D_FORTIFY_SOURCE=0"
  '';
}
