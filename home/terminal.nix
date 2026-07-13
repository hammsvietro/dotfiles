{ pkgs, ... }:

{
  programs.ghostty = {
    enable = true;
    package = pkgs.symlinkJoin {
      name = "ghostty-wrapped";
      paths = [ pkgs.ghostty ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/ghostty \
          --set GTK_IM_MODULE simple \
          --set GDK_DISABLE dmabuf
      '';
      meta.mainProgram = "ghostty";
    };

    settings = {
      cursor-style = "block";
      cursor-style-blink = false;
      background-opacity = 0.8;
      shell-integration = "none";

      working-directory = "home";
      window-inherit-working-directory = false;

      tab-inherit-working-directory = true;
      split-inherit-working-directory = true;
    };
  };
}
