{
  bisca,
  checklist,
  mango,
  nix-secrets,
  ...
}:

{
  imports = [
    nix-secrets.nixosModules.default
    bisca.nixosModules.default
    mango.nixosModules.mango
    checklist.nixosModules.default

    ../modules/system
    ../modules/home
  ];

}
