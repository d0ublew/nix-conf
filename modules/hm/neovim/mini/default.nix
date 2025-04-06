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
      # mini-pick
      mini-pairs
      mini-ai
      mini-surround
      mini-cursorword
      mini-completion
      mini-icons
      mini-clue
      mini-bracketed
      mini-trailspace
      mini-align
      mini-hipatterns
      mini-statusline
    ];

    xdg.configFile."nvim/lua/plugins/mini.lua".source = ./spec.lua;
  };
}
