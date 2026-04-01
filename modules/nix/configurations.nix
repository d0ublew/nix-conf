{ inputs, lib, ... }:
let
  mkStandaloneHome =
    {
      system,
      stateVersion,
      extraModules ? [ ],
      extraSpecialArgs ? { },
    }:
    let
      pkgs = inputs.nixpkgs.legacyPackages.${system};
    in
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        { home.stateVersion = stateVersion; }
      ] ++ extraModules;
      inherit extraSpecialArgs;
    };
in
{
  flake.lib = {
    inherit mkStandaloneHome;
  };
}
