{ config, lib, ... }:

{
  programs = {
    nix-ld.enable = true;

    nh = {
      enable = true;
      flake = "/home/jibi/nix-config";
    };
  };

  nix = {
    settings = {
      extra-substituters = lib.mkIf config.modules.desktop.enable [
        "https://cache.numtide.com?priority=100"
      ];
      extra-trusted-public-keys = lib.mkIf config.modules.desktop.enable [
        "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      ];

      system-features = [
        "uid-range"
      ];

      experimental-features = [
        "auto-allocate-uids"
        "cgroups"
        "flakes"
        "nix-command"
      ];

      auto-allocate-uids = true;
      use-cgroups = true;

      warn-dirty = false;
    };

    gc = {
      automatic = true;
      dates = "monthly";
      options = "--delete-older-than 30d";
    };
  };
}
