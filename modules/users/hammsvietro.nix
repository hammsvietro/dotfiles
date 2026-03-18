{ config, pkgs, ... }:
{
  users.users.hammsvietro = {
    isNormalUser = true;
    description = "Pedro Hamms Vietro";
    shell = pkgs.bash;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "audio"
      "gamemode"
      "input"
    ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  networking.networkmanager.enable = true;
}
