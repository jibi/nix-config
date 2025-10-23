{ pkgs, ... }:

{
  users.users.jibi = {
    isNormalUser = true;
    description = "Jibi";
    extraGroups = [
      "video"
      "networkmanager"
      "wheel"
      "docker"
      "plugdev"
      "libvirtd"
    ];
    shell = pkgs.zsh;
  };

  programs.gnupg.agent = {
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-curses;
  };
}
