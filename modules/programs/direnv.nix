{ inputs, ... }:
{
  flake.modules.homeManager.direnv =
    { pkgs, ... }:
    let
      pkgs-stable = inputs.nixpkgs-stable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      programs.direnv = {
        package = pkgs-stable.direnv;
        enable = true;
        enableBashIntegration = true;
        nix-direnv = {
          enable = true;
          package = pkgs.nix-direnv;
        };
      };
    };
}
