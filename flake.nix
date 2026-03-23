{
  description = "jibi's nixos config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-secrets.url = "git+ssh://git@github.com/jibi/nix-secrets";
    agenix = {
      url = "github:ryantm/agenix";
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
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      claude-code,
      agenix,
      bisca,
      mango,
      nix-secrets,
      ...
    }:
    let
      system = "x86_64-linux";
      specialArgs = {
        inherit
          agenix
          bisca
          claude-code
          home-manager
          mango
          nix-secrets
          ;
      };
      mkHost =
        name:
        nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules = [ ./hosts/${name} ];
        };
    in
    {
      nixosConfigurations = {
        xps = mkHost "xps";
        macbook = mkHost "macbook";
      };

      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-tree;
    };
}
