{
  description = "Work dev environment.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        python = pkgs.python314;
        pythonPackages = python.pkgs;

        lib-path =
          with pkgs;
          lib.makeLibraryPath [
            pythonPackages.python
            openssl
            stdenv.cc.cc
            unixodbc
            krb5
            libkrb5
            libuuid
            gcc
            zlib
          ];
      in
      {
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            pkg-config
            pythonPackages.cython
            pythonPackages.tomli-w
            pythonPackages.wheel
            pythonPackages.setuptools
            pythonPackages.python
          ];

          buildInputs = with pkgs; [
            # Python / Web Deps
            pythonPackages.gssapi
            pythonPackages.setuptools
            pythonPackages.tomli-w
            pythonPackages.pytest
            pythonPackages.pandas
            pythonPackages.tzdata
            pythonPackages.mypy
            pythonPackages.virtualenv
            zlib
            krb5
            libkrb5
            libuuid
            gcc
            pythonPackages.python

            # Go Deps
            go
            traefik

            # Cypress / Node Deps
            nodejs_22
            steam-run
            nss
            nspr
          ];

          shellHook = ''
            unset SOURCE_DATE_EPOCH

            VENV=.venv
            if [ ! -d "$VENV" ]; then
              uv venv
            fi
            source $VENV/bin/activate
            export PATH="$PWD/$VENV/bin:$PATH"

            export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${lib-path}:${pkgs.nss}/lib:${pkgs.nspr}/lib"

            export TZDIR=${pkgs.tzdata}/share/zoneinfo
            export NODE_OPTIONS="--max-old-space-size=2048"
            export MAKEFLAGS="SHELL=$SHELL"
            export PYTHONPATH=$PWD
            export CFLAGS="-I${pythonPackages.krb5}/include"
            export LDFLAGS="-L${pythonPackages.krb5}/lib"
            export TSAI_DISABLE_CSRF=True
            export TSAI_DISABLE_CSP=True
            export CC=gcc
            export CXX=g++
            export UV_NO_SYNC=1
            export UV_EXCLUDE_NEWER="1 week"
          '';

          packages = [
            pkgs.tzdata

            (pkgs.writeShellScriptBin "run-cypress" ''
              set -e
              steam-run npx cypress open
            '')

            (pkgs.writeShellScriptBin "make_etc" ''
              set -e
              make format
              make lint
              make test
            '')

            (pkgs.writeShellScriptBin "install-deps" ''
              set -euo pipefail

              if [ -z "$NEXUS_USERNAME" ] || [ -z "$NEXUS_PASSWORD" ]; then
                echo -e "\e[31mPlease set NEXUS_USERNAME and NEXUS_PASSWORD in your environment.\e[0m"
                exit 1
              fi

              export EXTRA_INDEX_URL="https://$NEXUS_USERNAME:$NEXUS_PASSWORD@nexus.dev.timeseer.ai/repository/timeseer/simple"

              LOCK_FILE="uv.lock"
              BACKUP_LOCK="uv.lock.bak"
              FILTERED_LOCK="uv.lock.filtered"
              PACKAGE_TO_REMOVE="gssapi"

              uv pip install tomli-w

              PACKAGE_TO_REMOVE="$PACKAGE_TO_REMOVE" python ~/dotfiles/dev-flakes/work/filter_packages.py

              mv "$LOCK_FILE" "$BACKUP_LOCK"
              mv "$FILTERED_LOCK" "$LOCK_FILE"

              cd packages/core && uv sync --frozen
              cd ../..
              cd packages/modules && uv sync --frozen
              cd ../..
              uv sync --extra-index-url="$EXTRA_INDEX_URL" --frozen
              mv "$BACKUP_LOCK" "$LOCK_FILE"

              uv pip install pytest mypy types-PyYAML types-python-dateutil types-requests ruff profilehooks

              make deps-typescript
              echo "Dependencies installed!"
            '')

            (pkgs.writeShellScriptBin "uv" ''
              export PATH="$PWD/.venv/bin:$PATH"
              exec ${pkgs.uv}/bin/uv "$@"
            '')
          ];
        };
      }
    );
}
