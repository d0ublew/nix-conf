{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  config = (
    mkMerge [
      {
        xdg.configFile."nvim/lua/plugins/colorscheme.lua".source = ./spec.lua;
      }
      (mkIf (builtins.elem "tokyonight" config.neovim-mod.colorschemes) {
        neovim-mod.extraPlugins = with pkgs.vimPlugins; [
          tokyonight-nvim
        ];

        xdg.configFile."nvim/lua/plugins/colorscheme/tokyonight.lua".source = ./tokyonight.lua;
      })
      (mkIf (builtins.elem "rose-pine" config.neovim-mod.colorschemes) {
        neovim-mod.extraPlugins = with pkgs.vimPlugins; [
          rose-pine
        ];

        xdg.configFile."nvim/lua/plugins/colorscheme/rose-pine.lua".source = ./rose-pine.lua;
      })
    ]
  );
}
