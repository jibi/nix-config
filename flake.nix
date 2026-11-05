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

  outputs = inputs: import ./outputs.nix inputs;
}
