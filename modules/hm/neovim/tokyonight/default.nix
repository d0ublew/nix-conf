{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options.neovim-mod.tokyonight = {
    enable = mkEnableOption "neovim tokyonight theme";
  };

  config = mkIf (config.neovim-mod.colorscheme == "tokyonight") {
    neovim-mod.extraPlugins = with pkgs.vimPlugins; [
      tokyonight-nvim
    ];

    xdg.configFile."nvim/lua/plugins/tokyonight.lua".source = ./spec.lua;
  };
}
