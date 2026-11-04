{
  config,
  lib,
  shared,
  wifiNetworks,
  ...
}:

let
  cfg = config.modules.networking;
  backend = cfg.wifi.backend;
  wg = shared.wg;
in
{
  options = {
    modules.networking = {
      wireguard.enable = lib.mkEnableOption "the home WireGuard NetworkManager profile";
      hosts = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
        description = "Named string aliases for hostnames";
      };
      wifi.backend = lib.mkOption {
        type = lib.types.nullOr (
          lib.types.enum [
            "nm"
            "wpa_supplicant"
          ]
        );
        default = null;
      };
    };
  };

  config = {
    networking = {
      networkmanager = lib.mkIf (backend == "nm") {
        enable = true;
        ensureProfiles = {
          environmentFiles = lib.optional cfg.wireguard.enable config.age.secrets.wg-private.path;
          profiles =
            (lib.mapAttrs (_: net: {
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
            }) wifiNetworks)
            // lib.optionalAttrs cfg.wireguard.enable {
              wg-home = {
                connection = {
                  id = "wg-home";
                  type = "wireguard";
                  interface-name = "wg0";
                  autoconnect = false;
                };
                wireguard = {
                  private-key = "$WG_PRIV";
                  listen-port = 0;
                };
                "wireguard-peer.${wg.serverPublicKey}" = {
                  endpoint = wg.endpoint;
                  allowed-ips = "0.0.0.0/0;";
                  persistent-keepalive = 25;
                };
                ipv4 = {
                  method = "manual";
                  address1 = "${wg.clients.xps.ip}/${toString wg.linkPrefix}";
                  dns = "192.168.1.1";
                  ignore-auto-dns = true;
                };
                ipv6.method = "disabled";
              };
            };
        };
      };

      wireless = lib.mkIf (backend == "wpa_supplicant") {
        enable = true;
        networks = lib.mapAttrs' (_: net: lib.nameValuePair net.ssid { psk = net.psk; }) wifiNetworks;
      };
    };
  };
}
