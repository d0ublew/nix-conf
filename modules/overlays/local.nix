{ withSystem, ... }:
{
  # Makes all perSystem packages available as pkgs.local.<name>
  flake.overlays.local = _final: prev: {
    local = withSystem prev.stdenv.hostPlatform.system (
      { config, ... }: config.packages
    );
  };
}
