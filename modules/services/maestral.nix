{ pkgs, ... }:

{
  systemd.user.services.maestral = {
    description = "Maestral Dropbox Client";

    wantedBy = [
      "graphical-session.target"
      "default.target"
    ];
    after = [
      "graphical-session.target"
      "default.target"
    ];

    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.maestral}/bin/maestral start -f";
      ExecStop = "${pkgs.maestral}/bin/maestral stop";

      Restart = "on-failure";
      RestartSec = "10s";

      MemoryHigh = "500M";
      MemoryMax = "1G";
    };
  };
}
