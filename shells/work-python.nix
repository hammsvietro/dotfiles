let
  pkgs = import <nixpkgs> { };
  python = pkgs.python312;
  pythonPackages = python.pkgs;
  lib-path = with pkgs;
    lib.makeLibraryPath [
      openssl
      stdenv.cc.cc
      unixODBC
      krb5 # MIT Kerberos libraries
      libkrb5 # Kerberos headers
      libuuid # UUID support (sometimes required)
      gcc # C compiler (in case it’s missing)
      zlib
    ];
in with pkgs;
mkShell {
  nativeBuildInputs = [
    pkg-config
    pythonPackages.cython
    pythonPackages.wheel
    pythonPackages.setuptools
    pkgs.uv
  ];

  buildInputs = [
    pythonPackages.gssapi
    pythonPackages.setuptools
    pythonPackages.pytest
    pythonPackages.pandas
    pythonPackages.mypy
    zlib
    nodejs
    pythonPackages.virtualenv
    krb5 # MIT Kerberos libraries
    libkrb5 # Kerberos headers
    libuuid # UUID support (sometimes required)
    gcc # C compiler (in case it’s missing)
  ];

  shellHook = ''
    VENV=.venv
    if [ ! -d "$VENV" ]; then
      uv venv --python=python3.12
    fi
    source $VENV/bin/activate
    export PATH="$PWD/$VENV/bin:$PATH"

    export MAKEFLAGS="SHELL=$SHELL"
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${lib-path}"

    export PYTHONPATH=$PWD
    export CFLAGS="-I${pythonPackages.krb5}/include"
    export LDFLAGS="-L${pythonPackages.krb5}/lib"
    export TSAI_DISABLE_CSRF=True
    export TSAI_DISABLE_CSP=True
    export CC=gcc
    export CXX=g++
    export UV_NO_SYNC=1
    export UV_NO_BUILD=1

    echo "Environment is set up!"
  '';

  packages = [
    (pkgs.writeShellScriptBin "make_etc" ''
      set -e
      make format
      make lint
      make test

    '')
    (pkgs.writeShellScriptBin "make-run" ''
      set -e

      FLASK_APP=timeseer.web FLASK_DEBUG=1 python -m flask run
    '')
    (pkgs.writeShellScriptBin "install-deps" ''
      set -e

      if [ -z "$NEXUS_USERNAME" ] || [ -z "$NEXUS_PASSWORD" ]; then
        echo "❌ Please set NEXUS_USERNAME and NEXUS_PASSWORD in your environment."
        exit 1
      fi


      export EXTRA_INDEX_URL="https://$NEXUS_USERNAME:$NEXUS_PASSWORD@nexus.dev.timeseer.ai/repository/timeseer/simple"
      uv pip freeze > unfiltered-requirements.txt
      grep -v '^gssapi' unfiltered-requirements.txt > filtered-requirements.txt

      uv pip sync --extra-index-url="$EXTRA_INDEX_URL" --reinstall filtered-requirements.txt

      rm filtered-requirements.txt unfiltered-requirements.txt

      uv pip install pytest mypy types-PyYAML types-python-dateutil types-requests ruff profilehooks
      echo "✅ Dependencies installed!"
    '')
    (pkgs.writeShellScriptBin "uv" ''
      export PATH="$PWD/.venv/bin:$PATH"
      exec ${pkgs.uv}/bin/uv "$@"
    '')
  ];
}
