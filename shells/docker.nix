with import <nixpkgs> { };

pkgs.mkShell {
  buildInputs = [ docker docker-compose ];

  shellHook = ''
    export MAKEFLAGS="SHELL=$SHELL"
  '';
}
