{
  inputs,
  commonModules,
  myvars,
}:

inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = inputs // {
    inherit myvars;
  };
  modules = commonModules ++ [
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
  ];
}
