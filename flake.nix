{
  description = "Pedro's NixOS and Home Manager config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      hmModule = {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.hammsvietro =
          import ./.config/home-manager/home.nix;
      };
    in {
      nixosConfigurations = {
        fractal = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/fractal/configuration.nix
            home-manager.nixosModules.home-manager
            hmModule
          ];
        };

        laptop = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/laptop/configuration.nix
            home-manager.nixosModules.home-manager
            hmModule
          ];
        };
      };
    };
}
