# rpi

## Building the SD image

```
mkdir -p tmp-keys/rpi
pass show hosts/rpi/ssh/ssh_host_ed25519_key     > tmp-keys/rpi/ssh_host_ed25519_key
pass show hosts/rpi/ssh/ssh_host_ed25519_key.pub > tmp-keys/rpi/ssh_host_ed25519_key.pub

nix build --impure .#nixosConfigurations.rpi.config.system.build.sdImage

rm -rf tmp-keys
```
