{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.neovim-mod.lsp.java;
in
{
  options.neovim-mod.lsp.java = {
    enable = mkEnableOption "neovim LSP for java";
  };

  config = mkIf cfg.enable {
    programs.neovim.extraPackages = with pkgs; [
      jdt-language-server
      google-java-format
    ];

    xdg.configFile."nvim/lua/plugins/lsp/java.lua".source = ./spec.lua;
  };
}
