{ lib, ... }: {
  imports = [
    ./pc-base.nix
    ./productivity.nix
    ./desktop-environment.nix
  ];
}
