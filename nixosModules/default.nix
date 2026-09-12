{ lib, ... }: {
  imports = [
    #./home-manager.nix
    ./pc-base.nix
    ./laptop.nix
    ./desktop-environment.nix
    ./productivity.nix
  ];
}
