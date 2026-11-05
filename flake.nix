{
  description = "jibi's nixos config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-secrets.url = "git+ssh://git@github.com/jibi/nix-secrets";
    home-manager.url = "github:nix-community/home-manager";
    bisca.url = "git+ssh://git@github.com/jibi/bisca";
    llm-agents.url = "github:numtide/llm-agents.nix";
    mango.url = "github:mangowm/mango";
    disko.url = "github:nix-community/disko";
    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";
    checklist.url = "path:/home/jibi/src/checklist";
    jetpack.url = "github:anduril/jetpack-nixos";

    nix-secrets.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    bisca.inputs.nixpkgs.follows = "nixpkgs";
    mango.inputs.nixpkgs.follows = "nixpkgs";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      nixpkgs,
      jetpack,
      nix-secrets,
      ...
    }:
    let
      mylib = import ./lib { lib = nixpkgs.lib; };

      specialArgs = inputs // {
        inherit mylib;
      };

      mkHost =
        {
          name,
          system ? "x86_64-linux",
          nixpkgsInput ? nixpkgs,
        }:
        nixpkgsInput.lib.nixosSystem {
          inherit system specialArgs;
          modules = [
            ./hosts/${name}
          ];
        };
    in
    {
      nixosConfigurations = {
        # hosts
        xps = mkHost {
          name = "xps";
        };
        rpi = mkHost {
          name = "rpi";
          system = "aarch64-linux";
        };
        jetson = mkHost {
          name = "jetson";
          system = "aarch64-linux";
          nixpkgsInput = jetpack.inputs.nixpkgs;
        };

        # ISO installer with SSH access
        installer-iso = import ./installers/generic.nix {
          inherit nixpkgs nix-secrets;
        };

        # jetson ISO installer with SSH access
        jetson-installer-iso = import ./installers/jetson.nix {
          inherit jetpack nix-secrets;
        };
      };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;
    };
}
