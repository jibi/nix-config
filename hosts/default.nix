{ inputs, mylib }:
let
  inherit (inputs) nixpkgs jetpack;

  specialArgs = inputs // {
    inherit mylib;
  };

  commonModules =
    map mylib.defaultModule [
      "nix-secrets"
      "bisca"
      "checklist"
    ]
    ++ [
      inputs.mango.nixosModules.mango

      ../modules/system
      ../modules/home
    ];

  mkHost =
    {
      name,
      system,
      nixpkgsInput ? nixpkgs,
    }:
    nixpkgsInput.lib.nixosSystem {
      inherit system specialArgs;
      modules = commonModules ++ [ ./${name} ];
    };
in
{
  xps = mkHost {
    name = "xps";
    system = "x86_64-linux";
  };

  rpi = mkHost {
    name = "rpi";
    system = "aarch64-linux";
  };

  jetson = mkHost {
    name = "jetson";
    system = "aarch64-linux";
    nixpkgsInput = jetpack.inputs.nixpkgs;
  };
}
