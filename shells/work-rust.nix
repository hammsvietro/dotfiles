{
  pkgs ? import <nixpkgs> { },
}:

pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    pkg-config
    openssl.dev
  ];

  shellHook = ''
    export PKG_CONFIG_PATH=${pkgs.openssl.dev}/lib/pkgconfig
    export CFLAGS="-O2 -D_FORTIFY_SOURCE=0"
  '';
}
