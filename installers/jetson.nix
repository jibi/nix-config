{
  inputs,
  commonModules,
  myvars,
}:

inputs.jetpack.nixosConfigurations.installer_minimal_cross_jp7.extendModules {
  specialArgs = inputs // {
    inherit myvars;
  };
  modules = commonModules;
}
