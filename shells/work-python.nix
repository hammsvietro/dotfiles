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
    ];
in with pkgs;
mkShell {
  nativeBuildInputs = [ pkg-config pythonPackages.cython pythonPackages.wheel ];
  buildInputs = [
    pythonPackages.gssapi
    pythonPackages.setuptools
    ruff
    uv
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
      python3.12 -m venv "$VENV"
    fi
    source $VENV/bin/activate

    export MAKEFLAGS="SHELL=$SHELL"
    export "LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${lib-path}"

    # Garantir que os headers e bibliotecas do Kerberos sejam encontrados
    export CFLAGS="-I${krb5.dev}/include"
    export LDFLAGS="-L${krb5.out}/lib"
    export CC=gcc
    export CXX=g++

    export TSAI_DISABLE_CSRF=True
    export TSAI_DISABLE_CSP=True
    export PATH=${lib.makeBinPath [ ruff ]}:$PATH
  '';

  packages = [
    (writeShellScriptBin "make_etc" "make format lint test")
    (writeShellScriptBin "install-deps" ''
      set -e

      VENV=.venv
      if [ ! -d "$VENV" ]; then
        python3.12 -m venv "$VENV"
      fi
      source $VENV/bin/activate

      # Instalar deps, mas ignorar gssapi para testar antes
      PIP_NO_BUILD_ISOLATION=1 PIP_EXISTS_ACTION=s \
        xargs -a <(grep -v '^gssapi' requirements-unix.txt) pip install

      # Se a instalação do gssapi falhar, podemos testar uma versão específica
      pip install "gssapi<1.9"

      echo "Dependencies installed!"
      make deps dev-deps
    '')
  ];
}
