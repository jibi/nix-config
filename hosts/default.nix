{
  bisca,
  claude-code,
  mango,
  nix-secrets,
  ...
}:

{
  imports = [
    ../modules/system
    ../modules/home
    nix-secrets.nixosModules.default
    bisca.nixosModules.default
    mango.nixosModules.mango
  ];

  nixpkgs.overlays = [
    claude-code.overlays.default
  ];
}
