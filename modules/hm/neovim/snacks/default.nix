{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.neovim-mod.snacks;
in
{
  options.neovim-mod.snacks = {
    enable = mkEnableOption "neovim snacks";
  };
  config = mkIf cfg.enable {
    neovim-mod.extraPlugins = with pkgs.vimPlugins; [
      snacks-nvim
    ];

    xdg.configFile."nvim/lua/plugins/snacks.lua".source = ./spec.lua;
  };
}
