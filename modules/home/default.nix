{
  config,
  llm-agents,
  mango,
  mylib,
  nix-secrets,
  home-manager,
  shared,
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
        shared
        ;
      modules = config.modules;
      homeBin = ".bin";
    };

    users.jibi =
      {
        modules,
        lib,
        ...
      }:
      {
        home.stateVersion = "25.05";

        imports = [
          ./zsh.nix
          ./ssh.nix
        ]
        ++ lib.optionals modules.desktop.enable [
          ./backup.nix
          ./ghostty.nix
          ./git.nix
          ./mango
          ./packages.nix
          ./vim
        ];
      };
  };
}
