{
  config,
  lib,
  pkgs-stable,
  ...
}:
with lib;
let
  cfg = config.neovim-mod.lsp.python;
in
{
  options.neovim-mod.lsp.python = {
    enable = mkEnableOption "neovim LSP for lua";
  };

  config = mkIf cfg.enable {
    programs.neovim.extraPackages = with pkgs-stable; [
      pyright
      ruff
    ];

    xdg.configFile."nvim/lua/plugins/lsp/python.lua".source = ./spec.lua;
  };
}
