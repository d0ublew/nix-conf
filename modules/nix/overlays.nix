{ ... }:
{
  flake.modules.homeManager.overlays = {
    nixpkgs.overlays = [
      (import ../../overlays/gef-bata24.nix)
    ];
  };
}
