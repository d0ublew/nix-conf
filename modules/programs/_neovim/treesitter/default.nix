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
          -- the curated queries live under `runtime/queries`, not `queries`;
          -- without this, `; inherits: ecma,jsx` in the js/ts/tsx queries
          -- resolves to nothing and those filetypes end up unhighlighted
          vim.opt.runtimepath:append("${pkgs-stable.vimPlugins.nvim-treesitter.withAllGrammars}/runtime")
          vim.opt.runtimepath:append("${grammarsPath}")
          -- parsers are managed by nix; `install_dir` is the only key
          -- `setup()` accepts on the `main` branch
          require("nvim-treesitter").setup {}

          -- `main` branch does not auto-enable highlight/indent anymore
          vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("d0ublew_treesitter", { clear = true }),
            callback = function(args)
              local lang = vim.treesitter.language.get_lang(args.match)
              if not (lang and vim.treesitter.language.add(lang)) then
                return
              end
              vim.treesitter.start(args.buf, lang)
              vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end,
          })
        end,
        lazy = false,
        -- event = "VeryLazy",
      }
    '';
  };
}
