{ nix-secrets, shared, ... }:

{
  imports = [
    ./shared.nix
    ./system/networking.nix
    nix-secrets.nixosModules.default
  ];

  modules.networking.wifi.backend = "nm";
  users.users.nixos.openssh.authorizedKeys.keys = [ shared.sshPubKey ];
}
