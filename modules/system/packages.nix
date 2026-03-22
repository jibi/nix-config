{ pkgs, agenix, ... }:

{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    agenix.packages.x86_64-linux.default
    curl
    jq
    neovim
    ripgrep
  ];

  programs.nix-ld.enable = true;
}
