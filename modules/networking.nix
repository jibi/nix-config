{ ... }:

{
  networking = {
    hostName = "nixos-xps";
    networkmanager.enable = true;
    firewall = {
      #allowedTCPPorts = [ 3000 5173 ];
      trustedInterfaces = [ "virbr0" ];
    };
  };
}
