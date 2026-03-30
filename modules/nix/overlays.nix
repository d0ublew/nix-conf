{ inputs, ... }:
{
  # Auto-apply all flake.overlays.* to Home Manager and NixOS configs
  flake.modules.homeManager.overlays = {
    nixpkgs.overlays = builtins.attrValues inputs.self.overlays;
  };
}
