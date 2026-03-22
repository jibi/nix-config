{ ... }:

{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.jibi = {
    home.stateVersion = "25.05";

    imports = [
      ./zsh.nix
      ./ssh.nix
      ./git.nix
    ];
  };
}
