{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    fzf
    sqlitebrowser
    sqlite-interactive
    tree-sitter

    cmake
    libtool

    go
    gopls

    pyright
    maturin
    (python314.withPackages (
      ps: with ps; [
        pyright
        python-lsp-server
        python-lsp-ruff
        ruff
        black
        isort
        mypy
        pip
        virtualenv
        setuptools
        gssapi
        uv
        pyflakes
      ]
    ))

    nodejs_22
    nodePackages.eslint
    nodePackages.prettier
    nodePackages.typescript
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted

    docker-compose

    nixfmt
    nixpkgs-fmt
    nil

    gcc
    pkg-config
    krb5.dev
    jemalloc
    openssl

    elixir
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
