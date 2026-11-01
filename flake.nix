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
      specialArgs = {
        inherit
          bisca
          checklist
          disko
          home-manager
          jetpack
          llm-agents
          mango
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
        }:
        nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules = [
            ./hosts/${name}
          ];
        };
    in
    {
      nixosConfigurations = {
        # hosts
        xps = mkHost { name = "xps"; };
        rpi = mkHost {
          name = "rpi";
          system = "aarch64-linux";
        };

        # ISO installer with SSH access
        installer-iso = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit nix-secrets; };
          modules = [
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
            ./modules/iso-installer.nix
          ];
        };

        # jetson ISO installer with SSH access
        jetson-installer-iso = jetpack.nixosConfigurations.installer_minimal_cross.extendModules {
          specialArgs = { inherit nix-secrets; };
          modules = [
            ./modules/iso-installer.nix
          ];
        };
      };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;
    };
}
