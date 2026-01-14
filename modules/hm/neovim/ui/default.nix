{
  config,
  lib,
  pkgs-stable,
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
    neovim-mod.extraPlugins = with pkgs-stable.vimPlugins; [
      # nvim-navic
      dropbar-nvim
      # nvim-web-devicons
      nui-nvim
      # indent-blankline-nvim
      # lualine-nvim
      nvim-notify
      # zen-mode-nvim
      # dressing-nvim
      mini-icons
      render-markdown-nvim
    ];

    xdg.configFile."nvim/lua/plugins/ui.lua".source = ./spec.lua;
  };
}
