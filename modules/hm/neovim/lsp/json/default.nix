{
  config,
  lib,
  pkgs-stable,
  ...
}:
with lib;
let
  cfg = config.neovim-mod.lsp.json;
in
{
  options.neovim-mod.lsp.json = {
    enable = mkEnableOption "neovim LSP for json";
  };

  config = mkIf cfg.enable {
    programs.neovim.extraPackages = with pkgs-stable; [
      vscode-langservers-extracted
      jq
    ];

    neovim-mod.extraPlugins = with pkgs-stable.vimPlugins; [
      SchemaStore-nvim
    ];

    neovim-mod.extraSpec = ''
      { import = "plugins.lsp.json_deps" },
    '';

    xdg.configFile."nvim/lua/plugins/lsp/json.lua".source = ./spec.lua;
    xdg.configFile."nvim/lua/plugins/lsp/json_deps/spec.lua".source = ./deps.lua;
  };
}
