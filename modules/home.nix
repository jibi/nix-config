{ ... }:

{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.jibi = {
    home.stateVersion = "25.05";

    imports = [
      ./home/alacritty.nix
      ./home/awesome
      ./home/git.nix
      ./home/ssh.nix
      ./home/xconfig.nix
      ./home/zsh.nix
    ];
  };
}
