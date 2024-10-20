{
  pkgs,
  lib,
  config,
  ...
}: {
  environment.shellAliases = {
    vim = "nvim";
    tm = "tmux";
    py3 = "python3";
  };
}
