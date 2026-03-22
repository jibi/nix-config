{
  config,
  lib,
  pkgs,
  ...
}:

{
  users.users.jibi = {
    isNormalUser = true;
    description = "Jibi";
    extraGroups = [
      "networkmanager"
      "wheel"
    ]
    ++ lib.optionals config.virtualisation.docker.enable [ "docker" ]
    ++ lib.optionals config.virtualisation.libvirtd.enable [ "libvirtd" ]
    ++ lib.optionals config.services.xserver.enable [
      "plugdev"
      "video"
    ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;
}
