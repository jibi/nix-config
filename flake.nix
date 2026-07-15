{
  description = "jibi's nixos config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # Pinned to the last nixos-unstable rev that has a cached rpi kernel, i.e. right before
    # db3b2013d5737a74bb4af2287a7931a558f727ca | linux-rpi: 6.12.62-1+rpt1 -> 6.12.75-1+rpt1
    nixpkgs-rpi-kernel.url = "github:NixOS/nixpkgs/77bb0683a4d1cd66d08ccfe62a851e1068fbd23a";
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
      nixpkgs,
      nixpkgs-rpi-kernel,
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
          nixpkgs-rpi-kernel
          nix-secrets
          rust-overlay
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
