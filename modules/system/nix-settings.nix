{ ... }:
{
  flake.modules.nixos.nix-settings =
    { config, lib, ... }:
    {
      options.unfree-pkgs = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "List of allowed unfree package names";
      };

      config = {
        nix.settings = {
          experimental-features = [
            "nix-command"
            "flakes"
          ];
          trusted-users = [
            "@wheel"
          ];
        };
        nixpkgs.config.allowUnfreePredicate = pkg:
          builtins.elem (lib.getName pkg) config.unfree-pkgs;
      };
    };

  # Standalone HM nix settings (sets nixpkgs.config which conflicts with useGlobalPkgs).
  # Import this in standalone user wrappers, NOT in NixOS-integrated HM.
  flake.modules.homeManager.nix-settings =
    { config, pkgs, lib, ... }:
    {
      nixpkgs.config.allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) config.unfree-pkgs;
      nix = {
        package = lib.mkDefault pkgs.nix;
        settings = {
          experimental-features = [
            "nix-command"
            "flakes"
          ];
          extra-substituters = [ "https://nix-community.cachix.org" ];
          extra-trusted-public-keys = [
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          ];
        };
      };
    };

  # Declare unfree-pkgs option for HM (always available via system-default).
  # Separate from nix-settings to avoid useGlobalPkgs conflicts.
  flake.modules.homeManager.unfree-pkgs =
    { lib, ... }:
    {
      options.unfree-pkgs = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "List of allowed unfree package names";
      };
    };
}
