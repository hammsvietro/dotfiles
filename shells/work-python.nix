let
  pkgs = import <nixpkgs> { };
  python = pkgs.python312;
  pythonPackages = python.pkgs;
  lib-path =
    with pkgs;
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
in
with pkgs;
mkShell {
  nativeBuildInputs = [
    pkg-config
    pythonPackages.cython
    pythonPackages.tomli-w
    pythonPackages.wheel
    pythonPackages.setuptools
  ];

  buildInputs = [
    pythonPackages.gssapi
    pythonPackages.setuptools
    pythonPackages.tomli-w
    pythonPackages.pytest
    pythonPackages.pandas
    pythonPackages.tzdata
    pythonPackages.mypy
    nodePackages.webpack
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
    export TZDIR=${pkgs.tzdata}/share/zoneinfo


    export NODE_OPTIONS="--max-old-space-size=2048"
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
      set -euo pipefail

      if [ -z "$NEXUS_USERNAME" ] || [ -z "$NEXUS_PASSWORD" ]; then
        echo "❌ Please set NEXUS_USERNAME and NEXUS_PASSWORD in your environment."
        exit 1
      fi

      export EXTRA_INDEX_URL="https://$NEXUS_USERNAME:$NEXUS_PASSWORD@nexus.dev.timeseer.ai/repository/timeseer/simple"

      LOCK_FILE="uv.lock"
      BACKUP_LOCK="uv.lock.bak"
      FILTERED_LOCK="uv.lock.filtered"
      PACKAGE_TO_REMOVE="gssapi"

      uv pip install tomli-w
      echo "🔍 Filtering out '$PACKAGE_TO_REMOVE' from $LOCK_FILE using filter_packages.py..."
      PACKAGE_TO_REMOVE="$PACKAGE_TO_REMOVE" python /home/hammsvietro/shells/filter_packages.py

      echo "📦 Syncing dependencies without '$PACKAGE_TO_REMOVE'..."
      mv "$LOCK_FILE" "$BACKUP_LOCK"
      mv "$FILTERED_LOCK" "$LOCK_FILE"
      uv sync --extra-index-url="$EXTRA_INDEX_URL" --frozen
      mv "$BACKUP_LOCK" "$LOCK_FILE"

      echo "📥 Installing dev tools..."
      uv pip install pytest mypy types-PyYAML types-python-dateutil types-requests ruff profilehooks

      make deps-typescript
      echo "✅ Dependencies installed!"
    '')

    (pkgs.writeShellScriptBin "uv" ''
      export PATH="$PWD/.venv/bin:$PATH"
      exec ${pkgs.uv}/bin/uv "$@"
    '')
  ];
}
