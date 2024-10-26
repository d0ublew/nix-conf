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

  imports = [
    ../modules/generic-wsl.nix
  ];

  networking.hostName = "my-nix";
  time.timeZone = "Asia/Jakarta";
}
