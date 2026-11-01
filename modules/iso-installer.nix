{ nix-secrets, shared, ... }:

{
  imports = [
    ./options.nix
    ./shared.nix
    ./system/networking.nix
    nix-secrets.nixosModules.default
  ];

  myconfig.wifi.backend = "nm";
  users.users.nixos.openssh.authorizedKeys.keys = [ shared.sshPubKey ];
}
