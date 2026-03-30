{ ... }:
let
  uname = "d0ublew";
in
{
  flake.modules.nixos.wsl =
    { lib, config, ... }:
    let
      mod = "wsl-mod";
      cfg = config.${mod};
    in
    {
      options.${mod} = {
        enable = lib.mkEnableOption "WSL";
        docker-desktop = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable docker desktop";
        };
      };

      config = lib.mkIf cfg.enable {
        wsl = {
          enable = true;
          defaultUser = uname;
          docker-desktop.enable = cfg.docker-desktop;
        };
      };
    };
}
