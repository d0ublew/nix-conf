{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  mod = "treesitter";
  cfg = config.neovim-mod.${mod};
  grammarsPath = pkgs.symlinkJoin {
    name = "nvim-treesitter-grammars";
    paths = pkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
  };
in
{
  options.neovim-mod.${mod} = {
    enable = mkEnableOption "neovim ${mod}";
  };
  config = mkIf cfg.enable {
    neovim-mod.extraPlugins = with pkgs.vimPlugins; [
      nvim-treesitter
    ];

    # xdg.configFile."nvim/lua/plugins/${mod}.lua".source = ./spec.lua;
    xdg.configFile."nvim/lua/plugins/${mod}.lua".text = ''
      return {
        dir = "${pkgs.vimPlugins.nvim-treesitter}",
        name = "nvim-treesitter",
        config = function ()
          vim.opt.runtimepath:append("${pkgs.vimPlugins.nvim-treesitter}")
          vim.opt.runtimepath:append("${grammarsPath}")
          require("nvim-treesitter.config").setup {
            -- they are managed by nix
            auto_install = false,

            highlight = {
              enable = true,
              additional_vim_regex_highlighting = false,
            },
            indent = { enable = true },
          }
        end,
        event = "VeryLazy",
      }
    '';
  };
}
