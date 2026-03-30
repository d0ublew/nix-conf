{ ... }:
{
  flake.modules.homeManager.lsd =
    { lib, ... }:
    {
      programs.lsd = {
        enable = true;
        enableBashIntegration = lib.mkDefault true;
        icons = lib.mkDefault true;
        colors = lib.mkDefault true;
      };
    };
}
