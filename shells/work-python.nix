let
  pkgs = import <nixpkgs> { };
  python = pkgs.python312;
  pythonPackages = python.pkgs;
  lib-path = with pkgs; lib.makeLibraryPath [ openssl stdenv.cc.cc unixODBC ];
in with pkgs;
mkShell {
  nativeBuildInputs = [ pkg-config pythonPackages.cython pythonPackages.wheel ];
  buildInputs = [
    pythonPackages.gssapi
    pythonPackages.setuptools
    ruff
    nodejs
    pythonPackages.virtualenv
  ];

  shellHook = ''
    VENV=venv
    if [ ! -d "$VENV" ]; then
      python3.12 -m venv "$VENV"
    fi
    source $VENV/bin/activate
    export MAKEFLAGS="SHELL=$SHELL"
    export "LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${lib-path}"
    TSAI_DISABLE_CSRF=True
    TSAI_DISABLE_CSP=True
    export PATH=${lib.makeBinPath [ ruff ]}:$PATH
  '';
  packages = [
    (writeShellScriptBin "install-deps" ''
      set -e

      VENV=venv
      if [ ! -d "$VENV" ]; then
        python3.12 -m venv "$VENV"
      fi
      source $VENV/bin/activate

      # Install deps but skip gssapi
      PIP_NO_BUILD_ISOLATION=1 PIP_EXISTS_ACTION=s \
        xargs -a <(grep -v '^gssapi' requirements-unix.txt) pip install
      echo "Dependencies installed!"

      make deps dev-deps
    '')
  ];
}
