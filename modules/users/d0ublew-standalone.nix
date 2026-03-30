{ inputs, config, ... }:
{
  flake.homeConfigurations."d0ublew" = config.flake.lib.mkStandaloneHome {
    system = "x86_64-linux";
    stateVersion = "24.05";
    extraModules = [
      inputs.self.modules.homeManager.nix-settings
      inputs.self.modules.homeManager.d0ublew
      ({ pkgs, ... }: {
        home.packages = [
          pkgs.local.ropr
        ];
      })
    ];
  };
}
