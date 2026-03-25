{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    curl
    jq
    neovim
    ripgrep
  ];

  programs.nix-ld.enable = true;
}
