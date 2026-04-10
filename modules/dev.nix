{
  config,
  pkgs,
  inputs,
  ...
}:

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
    eslint
    prettier
    typescript
    typescript-language-server
    vscode-langservers-extracted

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
    elixir-ls

    (rust-bin.stable.latest.default.override {
      extensions = [
        "rust-analyzer"
        "rust-src"
      ];
    })
  ];

  nixpkgs.overlays = [ inputs.rust-overlay.overlays.default ];
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
