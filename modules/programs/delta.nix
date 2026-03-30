{ ... }:
{
  flake.modules.homeManager.delta = {
    programs.delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        navigate = true;
        light = true;
        line-numbers = false;
      };
    };
  };
}
