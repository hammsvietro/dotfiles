{
  config,
  pkgs,
  inputs,
  ...
}:
{
  systemd.user.services.maestral = {
    description = "Maestral Dropbox Client";

    wantedBy = [ "default.target" ];
    after = [ "default.target" ];

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
