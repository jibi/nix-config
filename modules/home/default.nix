{
  llm-agents,
  mango,
  mylib,
  nix-secrets,
  home-manager,
  myvars,
  ...
}:

{
  imports = [ home-manager.nixosModules.home-manager ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    sharedModules = [ nix-secrets.homeManagerModules.default ];
    extraSpecialArgs = {
      inherit
        llm-agents
        mango
        mylib
        myvars
        ;
      homeBin = ".bin";
    };

    users.jibi = {
      home.stateVersion = "25.05";
      imports = [
        ./backup.nix
        ./zsh.nix
        ./ssh.nix
        ./ghostty.nix
        ./git.nix
        ./mango
        ./packages.nix
        ./vim
      ];
    };
  };
}
