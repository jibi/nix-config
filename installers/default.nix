{ nix-secrets, shared, ... }:

{
  imports = [
    ../modules/shared.nix
    ../modules/system/networking.nix
    nix-secrets.nixosModules.default
  ];

  modules.networking.wifi.backend = "nm";
  users.users.nixos.openssh.authorizedKeys.keys = [ shared.sshPubKey ];
}
