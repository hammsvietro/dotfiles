{ config, pkgs, ... }:

{
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    flake-registry = "/etc/nix/registry.json";
    auto-optimise-store = true;
    trusted-users = [
      "root"
      "hammsvietro"
    ];
  };

  nix.daemonCPUSchedPolicy = "batch";
  nix.daemonIOSchedClass = "idle";

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 3d";
  };

  nix.optimise = {
    automatic = true;
    dates = [ "daily" ];
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [ ruff ];
}
