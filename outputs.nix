inputs@{ nixpkgs, ... }:
let
  myvars = import ./vars;
  mylib = import ./lib {
    inherit inputs;
    lib = nixpkgs.lib;
  };

  hosts = import ./hosts { inherit inputs mylib myvars; };
  installers = import ./installers { inherit inputs mylib myvars; };
in
{
  nixosConfigurations = hosts // installers;
  formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;
}
