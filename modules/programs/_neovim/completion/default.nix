{
  config,
  lib,
  pkgs-stable,
  ...
}:
with lib;
let
  cfg = config.neovim-mod.completion;
in
# my-blink-cmp = pkgs-stable.callPackage ./blink-cmp.nix { };
{
  options.neovim-mod.completion = {
    enable = mkEnableOption "neovim completion";
  };
  config = mkIf cfg.enable {
    neovim-mod.extraPlugins = with pkgs-stable.vimPlugins; [
      # nvim-cmp
      # cmp-nvim-lsp
      # cmp-buffer
      # cmp-path
      blink-cmp
      friendly-snippets
      colorful-menu-nvim
      blink-copilot
    ];

    xdg.configFile."nvim/lua/plugins/completion.lua".source = ./spec.lua;
  };
}
