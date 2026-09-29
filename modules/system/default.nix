{ ... }:

{
  imports = [
    ../options.nix
    ../shared.nix
    ./nix.nix
    ./locale.nix
    ./boot.nix
    ./systemd.nix
    ./networking.nix
    ./users.nix
    ./packages.nix
    ./desktop.nix
    ./hardware.nix
    ./cuda.nix
  ];
}
