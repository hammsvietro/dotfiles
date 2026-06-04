{
  description = "ts-flows dev environment for NixOS";

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

        lib-path = pkgs.lib.makeLibraryPath [
          pythonPackages.python
          pkgs.openssl
          pkgs.stdenv.cc.cc
          pkgs.unixodbc
          pkgs.krb5
          pkgs.libkrb5
          pkgs.libuuid
          pkgs.gcc
          pkgs.zlib
        ];
      in
      {
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            pkg-config
            rustc
            cargo
            clippy
            rustfmt
            pythonPackages.python
            pythonPackages.setuptools
            pythonPackages.wheel
            pythonPackages.cython
            pythonPackages.tomli-w
          ];

          buildInputs = with pkgs; [
            pythonPackages.python
            pythonPackages.virtualenv
            pythonPackages.gssapi
            pythonPackages.pytest
            pythonPackages.pandas
            pythonPackages.tzdata
            pythonPackages.mypy
            pythonPackages.setuptools
            pythonPackages.tomli-w

            uv
            clang

            zlib
            openssl
            krb5
            libkrb5
            libuuid
            gcc
            stdenv.cc.cc
            unixodbc
          ];

          shellHook = ''
            unset SOURCE_DATE_EPOCH

            VENV=.venv
            if [ ! -d "$VENV" ]; then
              uv venv --python ${python}/bin/python
            fi
            source $VENV/bin/activate
            export PATH="$PWD/$VENV/bin:$PATH"

            export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${lib-path}"
            export TZDIR=${pkgs.tzdata}/share/zoneinfo
            export NODE_OPTIONS="--max-old-space-size=2048"
            export MAKEFLAGS="SHELL=$SHELL"
            export PYTHONPATH="$PWD:$PWD/timeseer/packages/core:$PWD/timeseer/packages/modules"
            export CFLAGS="-I${pkgs.krb5.dev}/include"
            export LDFLAGS="-L${pkgs.krb5}/lib"
            export CC=gcc
            export CXX=g++
            export UV_NO_SYNC=1
            export UV_EXCLUDE_NEWER="1 week"

            echo "Python: $(python --version)"
            echo "Rust: $(cargo --version)"
          '';
        };
      }
    );
}
