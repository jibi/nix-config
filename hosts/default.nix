{
  config,
  lib,
  bisca,
  mango,
  nix-secrets,
  ...
}:

{
  imports = [
    nix-secrets.nixosModules.default
    bisca.nixosModules.default
    mango.nixosModules.mango

    ../modules/system
    ../modules/home
  ];

  config = lib.mkIf config.myconfig.desktop.enable {
    nix.settings = {
      extra-substituters = [ "https://cache.numtide.com" ];
      extra-trusted-public-keys = [
        "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      ];
    };
  };
}
