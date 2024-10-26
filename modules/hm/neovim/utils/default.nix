{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  config = mkIf (true) {
    neovim-mod.extraPlugins = with pkgs.vimPlugins; [
      oil-nvim
      plenary-nvim
      fugitive
    ];

    xdg.configFile."nvim/lua/plugins/utils.lua".source = ./spec.lua;
  };
}
