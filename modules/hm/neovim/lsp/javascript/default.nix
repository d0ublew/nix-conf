{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.neovim-mod.lsp.javascript;
in
{
  options.neovim-mod.lsp.javascript = {
    enable = mkEnableOption "neovim LSP for javascript";
  };

  config = mkIf cfg.enable {
    programs.neovim.extraPackages = with pkgs; [
      biome
      typescript-language-server
    ];

    xdg.configFile."nvim/lua/plugins/lsp/javascript.lua".source = ./spec.lua;
  };
}
