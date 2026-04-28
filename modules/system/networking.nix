{
  config,
  lib,
  wifiNetworks,
  ...
}:

let
  backend = config.myconfig.wifi.backend;
in
{
  networking.networkmanager = lib.mkIf (backend == "nm") {
    enable = true;
    ensureProfiles.profiles = lib.mapAttrs (_: net: {
      connection = {
        id = net.ssid;
        type = "wifi";
      };
      wifi.ssid = net.ssid;
      wifi-security = {
        key-mgmt = "wpa-psk";
        psk = net.psk;
      };
      ipv4.method = "auto";
      ipv6.method = "auto";
    }) wifiNetworks;
  };

  networking.wireless = lib.mkIf (backend == "wpa_supplicant") {
    enable = true;
    networks = lib.mapAttrs' (_: net: lib.nameValuePair net.ssid { psk = net.psk; }) wifiNetworks;
  };
}
