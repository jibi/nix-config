{ inputs, commonModules }:

inputs.jetpack.nixosConfigurations.installer_minimal_cross_jp7.extendModules {
  specialArgs = inputs;
  modules = commonModules;
}
