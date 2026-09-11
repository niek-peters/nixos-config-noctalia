{ inputs, ... }: {
  home-manager."niek" = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      modules = [
        ./home.nix
        inputs.self.outputs.homeManagerModules.default
      ];
    };
  };
}
