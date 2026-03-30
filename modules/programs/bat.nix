{ ... }:
{
  flake.modules.homeManager.bat = {
    programs.bat = {
      enable = true;
      config = {
        theme = "ansi";
        style = "plain";
        paging = "never";
        pager = "less -FR";
      };
    };
  };
}
