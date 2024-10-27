{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.neovim-mod.lsp;
in
{
  imports = [
    ./nix
    ./lua
  ];

  options.neovim-mod.lsp = {
    enable = mkEnableOption "neovim LSP";
  };

  config = mkIf cfg.enable {
    neovim-mod.extraPlugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      conform-nvim
      fidget-nvim
      telescope-nvim
      actions-preview-nvim
    ];
    xdg.configFile."nvim/lua/plugins/lsp_config.lua".source = ./spec.lua;
  };
}
