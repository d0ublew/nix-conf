{
  config,
  lib,
  pkgs-stable,
  ...
}:
with lib;
let
  mod = "trouble";
  cfg = config.neovim-mod.${mod};
in
{
  options.neovim-mod.${mod} = {
    enable = mkEnableOption "neovim ${mod}";
  };
  config = mkIf cfg.enable {
    neovim-mod.extraPlugins = with pkgs-stable.vimPlugins; [
      trouble-nvim
    ];
    xdg.configFile."nvim/lua/plugins/${mod}.lua".source = ./spec.lua;
  };
}
