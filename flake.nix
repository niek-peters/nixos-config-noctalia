# config based on:
# https://github.com/vimjoyer/modularize-video
# https://youtu.be/vYc6IzKvAJQ?si=--q9v3yqnTtdUwbd

{
  description = "Main NixOS flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helium-flake = {
      url = "github:oxcl/nix-flake-helium-browser";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, ... }: {
    nixosConfiguration.default = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/acer-laptop/configuration.nix
        ./nixosModules
      ];
    };

    homeManagerModules.default = ./homeManagerModules;
    #nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
    #  system = "x86_64-linux";
    #  specialArgs = { inherit inputs; };
    #  modules = [
    #    ./configuration.nix
    #    home-manager.nixosModules.home-manager {
    #      home-manager = {
    #        extraSpecialArgs = {
    #          inherit inputs;
    #        };
    #        useGlobalPkgs = true;
    #        useUserPackages = true;
    #        users.niek = import ./home.nix;
    #        backupFileExtension = "backup";
    #      };
    #    }
    #  ];
    #};
  };
}
