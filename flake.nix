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
    claude-code = {
      url = "github:sadjow/claude-code-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mango = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      claude-code,
      bisca,
      mango,
      nix-secrets,
      disko,
      nixos-facter-modules,
      ...
    }:
    let
      specialArgs = {
        inherit
          bisca
          claude-code
          home-manager
          mango
          nix-secrets
          nixpkgs
          ;
      };
      mkHost =
        {
          name,
          system ? "x86_64-linux",
        }:
        nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules = [ ./hosts/${name} ];
        };
    in
    {
      nixosConfigurations = {
        # hosts
        xps = mkHost { name = "xps"; };
        macbook = mkHost { name = "macbook"; };
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
