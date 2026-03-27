{
  config,
  mango,
  nix-secrets,
  home-manager,
  ...
}:

{
  imports = [ home-manager.nixosModules.home-manager ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.sharedModules = [ nix-secrets.homeManagerModules.default ];
  home-manager.extraSpecialArgs = {
    inherit mango;
    isDesktop = config.myconfig.desktop.enable;
  };

  home-manager.users.jibi =
    { isDesktop, lib, ... }:
    {
      home.stateVersion = "25.05";

      imports = [
        ./vim
        ./zsh.nix
        ./ssh.nix
      ]
      ++ lib.optionals isDesktop [
        ./alacritty.nix
        ./awesome
        ./git.nix
        ./mango
        ./packages.nix
        ./xconfig.nix
      ];
    };
}
