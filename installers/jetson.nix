{ jetpack, nix-secrets }:

jetpack.nixosConfigurations.installer_minimal_cross_jp7.extendModules {
  specialArgs = { inherit nix-secrets; };
  modules = [ ./default.nix ];
}
