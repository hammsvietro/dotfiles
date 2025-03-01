let
  pkgs = import <nixpkgs> { };
  python = pkgs.python312;
  pythonPackages = python.pkgs;
  lib-path = with pkgs;
    lib.makeLibraryPath [ openssl stdenv.cc.cc unixODBC libuuid gcc ];
in pkgs.mkShell {
  nativeBuildInputs = [
    pkgs.pkg-config
    pythonPackages.cython
    pythonPackages.wheel
    pythonPackages.setuptools
    pkgs.uv # Using uv for dependency management
  ];

  buildInputs = [
    pythonPackages.gssapi # Ensure gssapi is installed via Nix
    pythonPackages.krb5 # Use Python's krb5 package instead of system-wide krb5
    pythonPackages.virtualenv
    pkgs.libuuid
    pkgs.gcc
  ];

  shellHook = ''
    VENV=.venv
    if [ ! -d "$VENV" ]; then
      uv venv --python=python3.12
    fi
    source $VENV/bin/activate

    export MAKEFLAGS="SHELL=$SHELL"
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${lib-path}"

    # Ensure proper headers for Kerberos
    export CFLAGS="-I${pythonPackages.krb5}/include"
    export LDFLAGS="-L${pythonPackages.krb5}/lib"
    export CC=gcc
    export CXX=g++

    echo "Environment is set up!"
  '';

  packages = [
    (pkgs.writeShellScriptBin "install-deps" ''
      set -e

      VENV=.venv
      if [ ! -d "$VENV" ]; then
        uv venv --python=python3.12
      fi
      source $VENV/bin/activate

      # Install dependencies excluding gssapi
      grep -v '^gssapi' requirements.txt > filtered-requirements.txt
      uv pip sync filtered-requirements.txt
      rm filtered-requirements.txt

      echo "Dependencies installed!"
    '')
  ];
}
