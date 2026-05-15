{ ... }:

{
  nix = {
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

      auto-allocate-uids = true;
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 1w";
    };
  };
}
