{ ... }:

{
  imports = [
    ./nix.nix
    ./locale.nix
    ./boot.nix
    ./systemd.nix
    ./networking.nix
    ./users.nix
    ./packages.nix
    ./overlays.nix
    ./desktop.nix
    ./hardware.nix
    ./fingerprint.nix
    ./nvidia.nix
  ];
}
