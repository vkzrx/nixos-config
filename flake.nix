{
  description = "NixOS system configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager }:
  let
    system = "x86_64-linux";
    unstable = import nixpkgs-unstable { inherit system; };
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit unstable; };
      modules = [
        ./modules/core/configuration.nix
        home-manager.nixosModules.home-manager {
          home-manager.extraSpecialArgs = {
            inherit unstable;
          };
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.vkzrx = import ./modules/home.nix;
        }
      ];
    };
  };
}
