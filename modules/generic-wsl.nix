{
  pkgs,
  lib,
  config,
  inputs,
  uname,
  ...
}:
with lib;
let
  mod = "wsl-mod";
  cfg = config.${mod};
in
{
  options.${mod} = {
    enable = mkEnableOption "WSL";
    docker-desktop = mkOption {
      type = types.bool;
      default = false;
      description = "Enable docker desktop";
    };
  };

  config = mkIf cfg.enable {
    wsl = {
      enable = true;
      defaultUser = "${uname}";
      docker-desktop.enable = cfg.docker-desktop;
    };
  };
}
