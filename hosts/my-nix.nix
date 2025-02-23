{
  pkgs,
  lib,
  config,
  inputs,
  uname,
  unfree-pkgs,
  ...
}:
{
  system.stateVersion = config.system.nixos.release;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.trusted-users = [
    "@wheel"
  ];

  imports = [
    ../modules/generic-wsl.nix
    ../modules/users.nix
    ../modules/packages.nix
    ../overlays
  ];

  networking.hostName = "my-nix";
  time.timeZone = "Asia/Jakarta";
  # nixpkgs.config.allowUnfree = true;
  # nixpkgs.overlays = import ../overlays { };
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) unfree-pkgs;
}
