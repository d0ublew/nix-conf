{ ... }:
{
  nixpkgs.overlays = [
    (import ./gef-bata24.nix)
  ];
}
