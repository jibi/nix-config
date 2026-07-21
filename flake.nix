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
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      llm-agents,
      bisca,
      mango,
      nix-secrets,
      disko,
      nixos-facter-modules,
      rust-overlay,
      ...
    }:
    let
      specialArgs = {
        inherit
          bisca
          home-manager
          llm-agents
          mango
          nixpkgs
          nix-secrets
          rust-overlay
          self
          ;
      };
      mkHost =
        {
          name,
          system ? "x86_64-linux",
          installer ? false,
        }:
        nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules = [
            ./hosts/${name}
          ]
          ++ nixpkgs.lib.optionals installer [
            disko.nixosModules.disko
            nixos-facter-modules.nixosModules.facter
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
          inherit specialArgs;
          modules = [
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
            ./modules/options.nix
            ./modules/shared.nix
            ./modules/system/networking.nix
            nix-secrets.nixosModules.default
            (
              { shared, ... }:
              {
                users.users.nixos.openssh.authorizedKeys.keys = [ shared.sshPubKey ];
                myconfig.wifi.backend = "nm";
              }
            )
          ];
        };
      };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;
    };
}
