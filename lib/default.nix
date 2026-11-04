{ lib }:

let
  hex2 = n: lib.fixedWidthString 2 "0" (lib.toLower (lib.toHexString n));
  toPrime =
    {
      bus,
      device,
      function,
    }:
    "PCI:${toString bus}:${toString device}:${toString function}";
  toPci =
    {
      bus,
      device,
      function,
    }:
    "0000:${hex2 bus}:${hex2 device}.${lib.toLower (lib.toHexString function)}";
in
{
  pciAddress =
    bus: device: function:
    let
      address = { inherit bus device function; };
    in
    address
    // {
      prime = toPrime address;
      pci = toPci address;
    };
}
