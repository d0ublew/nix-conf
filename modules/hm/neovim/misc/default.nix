{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  config = mkIf true {
    neovim-mod.extraPlugins = with pkgs.vimPlugins; [
      oil-nvim
      plenary-nvim
      fugitive
      vim-repeat
      undotree
      vim-unimpaired
      nvim-spectre
      which-key-nvim
      gitsigns-nvim
      vim-illuminate
    ];

    xdg.configFile."nvim/lua/plugins/misc.lua".source = ./spec.lua;
  };
}
