{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    coreutils

    bash

    gnumake
    fzf
    ripgrep
    fd
    jq
    sqlite-interactive

    # Python
    python312Packages.gssapi
    (python312.withPackages (ps: with ps; [ gssapi ]))
    python312Packages.pip
    python312Packages.virtualenv
    python312Packages.setuptools
    black

    # Rust
    rustup

    # TypeScript / JavaScript
    nodejs_20

    # Tools
    docker
    docker-compose
    nixfmt
    nixpkgs-fmt
    direnv
    nil # Nix LSP

    git
    krb5.dev
    gcc
    pkg-config
  ];

  programs.git.enable = true;
  programs.starship.enable = true;

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
}
