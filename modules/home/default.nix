{ mango, ... }:

{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = { inherit mango; };

  home-manager.users.jibi = {
    home.stateVersion = "25.05";

    imports = [
      ./zsh.nix
      ./ssh.nix
      ./git.nix
    ];
  };
}
