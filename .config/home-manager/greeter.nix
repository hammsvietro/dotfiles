{ ... }:

{
  programs.fish.interactiveShellInit = ''
    source ${./greeter/fish_greeting.fish}
  '';

  xdg.configFile."greeter/mandelbrot.awk".source = ./greeter/mandelbrot.awk;
}
