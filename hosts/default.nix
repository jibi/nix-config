{
  config,
  lib,
  bisca,
  llm-agents,
  mango,
  nix-secrets,
  ...
}:

{
  imports = [
    ../modules/system
    ../modules/home
    nix-secrets.nixosModules.default
    bisca.nixosModules.default
    mango.nixosModules.mango
  ];

  nixpkgs.overlays = lib.optional config.myconfig.desktop.enable llm-agents.overlays.default;

  nix.settings = lib.mkIf config.myconfig.desktop.enable {
    substituters = [ "https://cache.numtide.com" ];
    trusted-public-keys = [
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];
  };
}
