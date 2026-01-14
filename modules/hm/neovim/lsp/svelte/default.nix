{
  config,
  lib,
  pkgs-stable,
  ...
}:
with lib;
let
  lang = "svelte";
  cfg = config.neovim-mod.lsp.${lang};
in
{
  options.neovim-mod.lsp.${lang} = {
    enable = mkEnableOption "neovim LSP for ${lang}";
  };

  config = mkIf cfg.enable {
    programs.neovim.extraPackages = with pkgs-stable; [
      svelte-language-server
    ];

    xdg.configFile."nvim/lua/plugins/lsp/${lang}.lua".source = ./spec.lua;
  };
}
