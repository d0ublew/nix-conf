{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.neovim-mod.completion;
in
# my-blink-cmp = pkgs.callPackage ./blink-cmp.nix { };
{
  options.neovim-mod.completion = {
    enable = mkEnableOption "neovim completion";
  };
  config = mkIf cfg.enable {
    neovim-mod.extraPlugins = with pkgs.vimPlugins; [
      # nvim-cmp
      # cmp-nvim-lsp
      # cmp-buffer
      # cmp-path
      blink-cmp
      friendly-snippets
      colorful-menu-nvim
    ];

    xdg.configFile."nvim/lua/plugins/completion.lua".source = ./spec.lua;
  };
}
