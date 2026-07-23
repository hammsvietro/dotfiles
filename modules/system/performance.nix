# Shared CPU/RAM/IO tuning for all hosts; GPU tuning lives in modules/hardware.
{
  config,
  pkgs,
  lib,
  ...
}:
{
  boot.kernelParams = [
    "nowatchdog"
    "rq_affinity=1"
    "nvidia.NVreg_UsePageAttributeTable=1"
    "transparent_hugepage=always"
  ];

  boot.blacklistedKernelModules = [
    "sp5100_tco"
    "iTCO_wdt"
  ];

  powerManagement.cpuFreqGovernor = "performance";

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
    priority = 100;
  };

  services.scx = {
    enable = true;
    scheduler = "scx_lavd";
  };

  services.ananicy = {
    enable = true;
    package = pkgs.ananicy-cpp;
    rulesProvider = pkgs.ananicy-rules-cachyos;
  };

  services.udev.extraRules = ''
    ACTION=="add|change", KERNEL=="nvme[0-9]n[0-9]", ATTR{queue/scheduler}="none"
    ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="mq-deadline"
  '';

  boot.kernel.sysctl = {
    "vm.swappiness" = 100;
    "vm.page-cluster" = 0;
    "vm.compaction_proactiveness" = 0;
    "vm.dirty_ratio" = 15;
    "vm.dirty_background_ratio" = 5;
    "kernel.sched_autogroup_enabled" = 0;
    "kernel.split_lock_mitigate" = 0;
    "net.core.default_qdisc" = "cake";
    "net.ipv4.tcp_congestion_control" = "bbr";
  };

  boot.kernelModules = [ "tcp_bbr" ];
}
