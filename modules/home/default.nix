{
  config,
  llm-agents,
  mango,
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
        shared
        ;
      myconfig = config.myconfig;
    };

    users.jibi =
      {
        myconfig,
        lib,
        ...
      }:
      {
        home.stateVersion = "25.05";

        imports = [
          ./zsh.nix
          ./ssh.nix
        ]
        ++ lib.optionals myconfig.desktop.enable [
          ./alacritty.nix
          ./ghostty.nix
          ./git.nix
          ./mango
          ./packages.nix
          ./vim
        ];
      };
  };
}
