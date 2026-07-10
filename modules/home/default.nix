{
  config,
  mango,
  nix-secrets,
  home-manager,
  shared,
  ...
}:

{
  imports = [ home-manager.nixosModules.home-manager ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.sharedModules = [ nix-secrets.homeManagerModules.default ];
  home-manager.extraSpecialArgs = {
    inherit mango shared;
    isDesktop = config.myconfig.desktop.enable;
    displayScale = config.myconfig.display.scale;
  };

  home-manager.users.jibi =
    {
      isDesktop,
      displayScale,
      lib,
      ...
    }:
    {
      home.stateVersion = "25.05";

      imports = [
        ./zsh.nix
        ./ssh.nix
      ]
      ++ lib.optionals isDesktop [
        ./alacritty.nix
        ./ghostty.nix
        ./git.nix
        ./mango
        ./packages.nix
        ./vim
      ];
    };
}
