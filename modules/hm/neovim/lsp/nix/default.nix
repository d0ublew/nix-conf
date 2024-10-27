{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.neovim-mod.lsp.nix;
in
{
  options.neovim-mod.lsp.nix = {
    enable = mkEnableOption "neovim LSP for nix";
  };

  config = mkIf cfg.enable {
    programs.neovim.extraPackages = with pkgs; [
      nixd
      nixfmt-rfc-style
    ];

    xdg.configFile."nvim/lua/plugins/lsp/nix.lua".source = ./spec.lua;
  };
}
