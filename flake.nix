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
    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helium-flake = {
      url = "github:oxcl/nix-flake-helium-browser";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    obsidian-extensions = {
      url = "github:karaolidis/nix-obsidian-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:gerg-l/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      obsidian-extensions,
      ...
    }@inputs:
    let
      hosts = [
        {
          username = "niek";
          hostname = "nixos-acer-laptop";
          system = "x86_64-linux";
        }
      ];

      mkNixosConfiguration =
        {
          username,
          hostname,
          system,
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs username hostname;
          };
          modules = [
            ./hosts/${hostname}/configuration.nix
            ./hosts/${hostname}/hardware-configuration.nix
            ./nixosModules

            home-manager.nixosModules.home-manager
            {
              home-manager = {
                extraSpecialArgs = {
                  inherit inputs username hostname;
                };
                useGlobalPkgs = true;
                useUserPackages = true;
                users.${username} = {
                  imports = [
                    ./hosts/${hostname}/home.nix
                    ./homeManagerModules
                  ];
                };
                backupFileExtension = "backup";
              };
            }

            {
              nixpkgs.overlays = [
                obsidian-extensions.overlays.default
              ];
            }
          ];
        };
    in
    {
      nixosConfigurations = builtins.listToAttrs (
        map (host: {
          name = host.hostname;
          value = mkNixosConfiguration host;
        }) hosts
      );
    };
}
