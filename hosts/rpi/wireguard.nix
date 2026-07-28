{
  config,
  lib,
  pkgs,
  shared,
  ...
}:

let
  wg = shared.wg;

  iptables = "${pkgs.iptables}/bin/iptables";

  rules = op: ''
    ${iptables} -t nat -${op} POSTROUTING -s ${wg.linkSubnet} -o wlan0 -j MASQUERADE
  '';
in
{
  networking = {
    firewall = {
      allowedUDPPorts = [ wg.port ];
      checkReversePath = "loose";
      trustedInterfaces = [ "wg0" ];
    };

    wireguard.interfaces.wg0 = {
      ips = [ "${wg.serverIp}/${toString wg.linkPrefix}" ];
      listenPort = wg.port;
      privateKeyFile = config.age.secrets.wg-private.path;

      peers = lib.mapAttrsToList (_: c: {
        publicKey = c.publicKey;
        allowedIPs = [ "${c.ip}/32" ];
      }) wg.clients;

      postSetup = rules "A";
      postShutdown = rules "D";
    };
  };

  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
}
