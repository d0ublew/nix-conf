{
  pkgs,
  lib,
  config,
  inputs,
  uname,
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
  # nixpkgs.overlays = import ../overlays { };
}
