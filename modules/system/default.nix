{ ... }:

{
  imports = [
    ./nix.nix
    ./locale.nix
    ./boot.nix
    ./networking.nix
    ./users.nix
    ./packages.nix
  ];
}
