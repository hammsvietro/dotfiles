{
  description = "Pedro's NixOS and Home Manager config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let system = "x86_64-linux";
    in {
      nixosConfigurations = {
        fractal = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/fractal/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.hammsvietro =
                import ./.config/home-manager/home.nix;
            }
          ];
        };

        laptop = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/laptop/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.hammsvietro =
                import ./.config/home-manager/home.nix;
            }
          ];
        };
      };
    };
}
