{
  config,
  lib,
  pkgs-stable,
  ...
}:
with lib;
let
  cfg = config.neovim-mod.misc;
in
{
  options.neovim-mod.misc = {
    enable = mkEnableOption "neovim misc";
  };
  config = mkIf cfg.enable {
    neovim-mod.extraPlugins = with pkgs-stable.vimPlugins; [
      oil-nvim
      quicker-nvim
      plenary-nvim
      fugitive
      vim-repeat
      undotree
      vim-unimpaired
      grug-far-nvim
      # nvim-spectre
      # which-key-nvim
      gitsigns-nvim
      vim-illuminate
      # indent-o-matic
      guess-indent-nvim
    ];

    xdg.configFile."nvim/lua/plugins/misc.lua".source = ./spec.lua;
  };
}
