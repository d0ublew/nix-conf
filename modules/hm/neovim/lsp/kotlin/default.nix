{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.neovim-mod.lsp.kotlin;
  lang = "kotlin";
in
{
  options.neovim-mod.lsp.${lang} = {
    enable = mkEnableOption "neovim LSP for ${lang}";
  };

  config = mkIf cfg.enable {
    programs.neovim.extraPackages = with pkgs; [
      kotlin-language-server
      ktfmt
    ];

    xdg.configFile."nvim/lua/plugins/lsp/${lang}.lua".source = ./spec.lua;
  };
}
