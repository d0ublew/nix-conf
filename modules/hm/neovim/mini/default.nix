{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.neovim-mod.mini;
in
{
  options.neovim-mod.mini = {
    enable = mkEnableOption "neovim mini";
  };
  config = mkIf cfg.enable {
    neovim-mod.extraPlugins = with pkgs.vimPlugins; [
      mini-pairs
      mini-ai
      mini-surround
      mini-cursorword
      mini-completion
      mini-icons
    ];

    xdg.configFile."nvim/lua/plugins/mini.lua".source = ./spec.lua;
  };
}
