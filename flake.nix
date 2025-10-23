{
  description = "jibi's NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    claude-code = {
      url = "github:sadjow/claude-code-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-secrets.url = "git+ssh://git@github-nix-secrets/jibi/nix-secrets";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      claude-code,
      nix-secrets,
      ...
    }:
    {
      nixosConfigurations.nixos-xps = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit claude-code; };

        modules = [
          ./hardware-configuration.nix

          ./modules/system.nix
          ./modules/boot.nix
          ./modules/hardware.nix
          ./modules/networking.nix
          ./modules/xserver.nix
          ./modules/packages.nix
          ./modules/users.nix
          ./modules/cuda.nix

          home-manager.nixosModules.home-manager
          ./modules/home.nix

          nix-secrets.nixosModules.xps
        ];
      };
    };
}
