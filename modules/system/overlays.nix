{ mylib, ... }:
{
  nixpkgs.overlays = import ../../overlays { inherit mylib; };
}
