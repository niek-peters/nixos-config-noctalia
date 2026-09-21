# { inputs, ... }: {
#   inputs.home-manager."niek" = {
#     extraSpecialArgs = { inherit inputs; };
#     useGlobalPkgs = true;
#     useUserPackages = true;
#     users = {
#       modules = [
#         ./home.nix
#         inputs.self.outputs.homeManagerModules.default
#       ];
#     };
#   };
# }
