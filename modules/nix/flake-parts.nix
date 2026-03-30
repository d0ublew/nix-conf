{ inputs, lib, ... }:
{
  imports = [
    inputs.flake-parts.flakeModules.modules
  ];

  config.systems = [
    "x86_64-linux"
    "aarch64-darwin"
  ];

  # Declare homeConfigurations as a mergeable option so multiple host modules
  # can each define their own configuration. nixosConfigurations is already
  # declared by flake-parts.flakeModules.modules.
  options.flake = lib.mkOption {
    type = lib.types.submoduleWith {
      modules = [
        {
          options.homeConfigurations = lib.mkOption {
            type = lib.types.lazyAttrsOf lib.types.raw;
            default = { };
          };
        }
      ];
    };
  };
}
