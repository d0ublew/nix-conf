{
  config,
  lib,
  pkgs-stable,
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
    programs.neovim.extraPackages = with pkgs-stable; [
      biome
      typescript-language-server
    ];

    xdg.configFile."nvim/lua/plugins/lsp/javascript.lua".source = ./spec.lua;
  };
}
