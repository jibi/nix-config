inputs@{ nixpkgs, ... }:
let
  mylib = import ./lib {
    inherit inputs;
    lib = nixpkgs.lib;
  };

  hosts = import ./hosts { inherit inputs mylib; };
  installers = import ./installers { inherit inputs mylib; };
in
{
  nixosConfigurations = hosts // installers;
  formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;
}
