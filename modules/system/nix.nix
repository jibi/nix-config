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
