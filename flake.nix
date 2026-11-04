{
  description = "jibi's nixos config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-secrets = {
      url = "git+ssh://git@github.com/jibi/nix-secrets";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    bisca = {
      url = "git+ssh://git@github.com/jibi/bisca";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    llm-agents.url = "github:numtide/llm-agents.nix";
    mango = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";
    checklist.url = "path:/home/jibi/src/checklist";
    jetpack.url = "github:anduril/jetpack-nixos";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      jetpack,
      llm-agents,
      bisca,
      mango,
      nix-secrets,
      disko,
      nixos-facter-modules,
      checklist,
      ...
    }:
    let
      mylib = import ./lib { lib = nixpkgs.lib; };
      specialArgs = {
        inherit
          bisca
          checklist
          disko
          home-manager
          jetpack
          llm-agents
          mango
          mylib
          nixpkgs
          nix-secrets
          nixos-facter-modules
          self
          ;
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
