{ config, pkgs, ... }:
{
  programs.zsh.enable = true;
  networking.networkmanager.enable = true;

  users.users.hammsvietro = {
    isNormalUser = true;
    description = "Pedro Hamms Vietro";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "audio"
      "gamemode"
      "input"
      "kvm"
      "adbusers"
      "libvirtd"
    ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

}
