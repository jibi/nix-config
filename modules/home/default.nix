{
  config,
  llm-agents,
  mango,
  nix-secrets,
  home-manager,
  rust-overlay,
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
        rust-overlay
        shared
        ;
      myconfig = config.myconfig;
      homeBin = ".bin";
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
