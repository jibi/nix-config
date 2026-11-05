{ inputs, mylib }:
let
  commonModules = map mylib.defaultModule [ "nix-secrets" ] ++ [
    ../modules/shared.nix
    ../modules/system/networking.nix
    ({ shared, ... }: {
      modules.networking.wifi.backend = "nm";
      users.users.nixos.openssh.authorizedKeys.keys = [ shared.sshPubKey ];
    })
  ];
in
{
  installer-iso = import ./generic.nix { inherit inputs commonModules; };
  jetson-installer-iso = import ./jetson.nix { inherit inputs commonModules; };
}
