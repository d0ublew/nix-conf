{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  lang = "nim";
  cfg = config.neovim-mod.lsp.${lang};
in
{
  options.neovim-mod.lsp.${lang} = {
    enable = mkEnableOption "neovim LSP for ${lang}";
  };

  config = mkIf cfg.enable {
    programs.neovim.extraPackages = with pkgs; [
      nimlangserver
    ];

    xdg.configFile."nvim/lua/plugins/lsp/${lang}.lua".source = ./spec.lua;
  };
}
