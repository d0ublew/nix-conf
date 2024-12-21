{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.neovim-mod.ui;
in
{
  options.neovim-mod.ui = {
    enable = mkEnableOption "neovim UI config";
  };
  config = mkIf cfg.enable {
    neovim-mod.extraPlugins = with pkgs.vimPlugins; [
      nvim-navic
      # nvim-web-devicons
      nui-nvim
      indent-blankline-nvim
      lualine-nvim
      nvim-notify
      zen-mode-nvim
      dressing-nvim
    ];

    xdg.configFile."nvim/lua/plugins/ui.lua".source = ./spec.lua;
  };
}
