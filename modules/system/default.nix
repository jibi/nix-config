{ ... }:

{
  imports = [
    ../options.nix
    ../shared.nix
    ./nix.nix
    ./locale.nix
    ./boot.nix
    ./networking.nix
    ./users.nix
    ./packages.nix
    ./xserver.nix
    ./hardware.nix
    ./cuda.nix
  ];
}
