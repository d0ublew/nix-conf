{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.neovim-mod.telescope;
in
{
  options.neovim-mod.telescope = {
    enable = mkEnableOption "neovim telescope";
  };
  config = mkIf cfg.enable {
    neovim-mod.extraPlugins = with pkgs.vimPlugins; [
      telescope-nvim
      telescope-fzf-native-nvim
      telescope-ui-select-nvim
      plenary-nvim
    ];

    xdg.configFile."nvim/lua/plugins/telescope.lua".source = ./spec.lua;
  };
}
