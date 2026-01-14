{
  config,
  lib,
  pkgs-stable,
  ...
}:
with lib;
let
  lang = "dart";
  cfg = config.neovim-mod.lsp.${lang};
in
{
  options.neovim-mod.lsp.${lang} = {
    enable = mkEnableOption "neovim LSP for ${lang}";
  };

  config = mkIf cfg.enable {
    programs.neovim.extraPackages = with pkgs-stable; [
      # gopls
      # gofumpt
    ];

    xdg.configFile."nvim/lua/plugins/lsp/${lang}.lua".source = ./spec.lua;
  };
}
