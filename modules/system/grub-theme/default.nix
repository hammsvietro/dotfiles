{ stdenv, imagemagick }:

stdenv.mkDerivation {
  pname = "grub-theme-mandelbrot";
  version = "1.0.0";

  src = ./.;

  nativeBuildInputs = [ imagemagick ];

  buildPhase = ''
    runHook preBuild
    $CC -O2 -o mandelbrot mandelbrot.c -lm
    ./mandelbrot 1920 1080 > background.ppm
    magick background.ppm background.png
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp background.png theme.txt $out/
    runHook postInstall
  '';
}
