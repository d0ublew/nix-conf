{ ... }:
{
  flake.modules.homeManager.uv = {
    programs.uv = {
      enable = true;
      settings = {
        python-preference = "managed";
      };
    };
  };
}
