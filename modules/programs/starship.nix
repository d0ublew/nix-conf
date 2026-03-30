{ ... }:
{
  flake.modules.homeManager.starship =
    { lib, ... }:
    {
      programs.starship = {
        enable = lib.mkDefault true;
        enableBashIntegration = lib.mkDefault true;
      settings = {
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };
      };
    };
  };
}
