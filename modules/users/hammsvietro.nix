{ config, pkgs, ... }:
{
  programs.fish.enable = true;
  networking.networkmanager.enable = true;

  users.users.hammsvietro = {
    isNormalUser = true;
    description = "Pedro Hamms Vietro";
    shell = pkgs.fish;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "audio"
      "gamemode"
      "input"
      "kvm"
      "libvirtd"
    ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

}
