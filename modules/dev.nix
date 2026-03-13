{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Core dev utilities
    fzf
    sqlitebrowser
    sqlite-interactive
    tree-sitter

    # Golang
    go
    gopls

    # Python
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

    # JavaScript / TypeScript
    nodejs_22
    nodePackages.eslint
    nodePackages.prettier
    nodePackages.typescript
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted

    # Docker (already in apps, remove if desired)
    docker-compose

    # Nix
    nixfmt
    nixpkgs-fmt
    nil

    # Build deps (for Doom Emacs, Rust, etc.)
    gcc
    pkg-config
    krb5.dev
    jemalloc
    openssl

    # Elixir
    elixir
  ];

  # Direnv with nix-direnv at the system level
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
