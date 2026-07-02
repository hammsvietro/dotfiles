{ ... }:

{
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = [ "zen.desktop" ];
      "x-scheme-handler/http" = [ "zen.desktop" ];
      "x-scheme-handler/https" = [ "desktop" ];

      "text/plain" = [ "kate.desktop" ];

      "image/png" = [ "org.gnome.Loupe.desktop" ];
      "image/jpeg" = [ "org.gnome.Loupe.desktop" ];

      "video/mp4" = [ "mpv.desktop" ];
      "video/mkv" = [ "mpv.desktop" ];
      "audio/mpeg" = [ "mpv.desktop" ];

      "application/pdf" = [ "zen.desktop" ];

      "inode/directory" = [ "thunar.desktop" ];
    };
  };
}
