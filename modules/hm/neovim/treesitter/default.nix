{
  config,
  lib,
  pkgs-stable,
  ...
}:
with lib;
let
  mod = "treesitter";
  cfg = config.neovim-mod.${mod};
  grammarsPath = pkgs-stable.symlinkJoin {
    name = "nvim-treesitter-grammars";
    paths = pkgs-stable.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
  };
in
{
  options.neovim-mod.${mod} = {
    enable = mkEnableOption "neovim ${mod}";
  };
  config = mkIf cfg.enable {
    neovim-mod.extraPlugins = with pkgs-stable.vimPlugins; [
      nvim-treesitter.withAllGrammars
    ];

    # xdg.configFile."nvim/lua/plugins/${mod}.lua".source = ./spec.lua;
    xdg.configFile."nvim/lua/plugins/${mod}.lua".text = ''
      return {
        dir = "${pkgs-stable.vimPlugins.nvim-treesitter.withAllGrammars}",
        name = "nvim-treesitter",
        config = function ()
          vim.opt.runtimepath:append("${pkgs-stable.vimPlugins.nvim-treesitter.withAllGrammars}")
          vim.opt.runtimepath:append("${grammarsPath}")
          require("nvim-treesitter.configs").setup {
            -- install_dir = "${grammarsPath}",
            -- they are managed by nix
            auto_install = false,

            highlight = {
              enable = true,
              additional_vim_regex_highlighting = false,
            },
            indent = { enable = true },
          }
        end,
        lazy = false,
        -- event = "VeryLazy",
      }
    '';
  };
}
