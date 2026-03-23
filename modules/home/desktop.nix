{ ... }:

{
  home-manager.users.jibi = {
    imports = [
      ./packages.nix
      ./alacritty.nix
      ./xconfig.nix
      ./awesome
      ./mango
    ];
  };
}
