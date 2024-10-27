{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.neovim-mod.lsp.lua;
in
{
  options.neovim-mod.lsp.lua = {
    enable = mkEnableOption "neovim LSP for lua";
  };

  config = mkIf cfg.enable {
    programs.neovim.extraPackages = with pkgs; [
      lua-language-server
      stylua
    ];

    xdg.configFile."nvim/lua/plugins/lsp/lua.lua".source = ./spec.lua;
  };
}
