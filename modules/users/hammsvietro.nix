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
    ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  networking.networkmanager.enable = true;
}
