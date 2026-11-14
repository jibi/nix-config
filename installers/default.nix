{
  inputs,
  mylib,
  myvars,
}:
let
  commonModules = map mylib.defaultModule [ "nix-secrets" ] ++ [
    ../modules/system/networking.nix
    ({ myvars, ... }: {
      modules.networking.wifi.backend = "nm";
      users.users.nixos.openssh.authorizedKeys.keys = [ myvars.sshPubkey ];
    })
  ];
in
{
  installer-iso = import ./generic.nix { inherit inputs commonModules myvars; };
  jetson-installer-iso = import ./jetson.nix { inherit inputs commonModules myvars; };
}
