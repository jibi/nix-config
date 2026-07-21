{ pkgs, ... }:

{
  nix = {
    package = pkgs.lix;

    settings = {
      system-features = [
        "uid-range"
      ];

      experimental-features = [
        "auto-allocate-uids"
        "cgroups"
        "flakes"
        "nix-command"
      ];

      extra-deprecated-features = [
        "broken-string-escape"
      ];

      auto-allocate-uids = true;
      use-cgroups = true;
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
