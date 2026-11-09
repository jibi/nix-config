# see NixOS/nixpkgs#580890
final: prev: {
  appimageTools = prev.appimageTools.override {
    buildFHSEnv = final.lib.extendMkDerivation {
      constructDrv = final.buildFHSEnv;
      extendDrvArgs = _: args: {
        targetPkgs = pkgs: args.targetPkgs pkgs ++ [ pkgs.libgpg-error ];
      };
    };
  };
}
