{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    # Core utilities
    coreutils
    bash
    gnumake
    fzf
    ripgrep
    fd
    jq
    sqlite-interactive
    tree-sitter # Syntax tree parsing for Doom Emacs
    lsof

    # Golang
    go
    gopls

    # Python Development
    pyright
    maturin
    (python312.withPackages (ps:
      with ps; [
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
      ]))

    # Rust Development
    rustup

    # JavaScript / TypeScript / React Development
    nodejs
    nodePackages.pnpm
    nodePackages.yarn
    nodePackages.npm

    # JavaScript & TypeScript Development
    nodePackages.eslint
    nodePackages.prettier
    nodePackages.typescript
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted # LSP for eslint, json, css, etc.

    # Docker
    docker
    docker-compose

    # Nix Development
    nixfmt
    nixpkgs-fmt
    nil # Nix LSP

    # Doom Emacs dependencies
    git
    gcc
    pkg-config
    krb5.dev

    jq

    # Elixir
    elixir
  ];

  # Enable Git
  programs.git.enable = true;

  programs.starship.enable = true;
  # Enable Direnv (for automatic environment management)
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
}
