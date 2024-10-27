{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  mod = "neovim-mod";
  cfg = config.${mod};
in
{
  imports = [
    ./tokyonight
    ./misc
    ./lsp
    ./telescope
    ./completion
  ];
  # https://github.com/azuwis/nix-config/blob/52a6c657fb8031d5690f8971c52dc5c95c2f91b6/common/lazyvim/base/default.nix
  options.${mod} =
    let
      pluginsOptionType =
        let
          inherit (lib.types)
            listOf
            oneOf
            package
            str
            submodule
            ;
        in
        listOf (oneOf [
          package
          (submodule {
            options = {
              name = mkOption { type = str; };
              path = mkOption { type = package; };
            };
          })
        ]);
    in
    {
      enable = mkEnableOption "Neovim config";
      plugins = mkOption {
        type = pluginsOptionType;
        default = with pkgs.vimPlugins; [
          vim-unimpaired
          telescope-fzf-native-nvim
        ];
      };
      extraPlugins = mkOption {
        type = pluginsOptionType;
        default = [ ];
      };

      excludePlugins = mkOption {
        type = pluginsOptionType;
        default = [ ];
      };

      extraSpec = mkOption {
        type = lib.types.lines;
        default = "";
      };

      colorscheme = mkOption {
        type = lib.types.enum [
          "default"
          "tokyonight"
        ];
        default = "default";
      };
    };

  # https://github.com/LazyVim/LazyVim/discussions/1972
  config = mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      withNodeJs = false;
      extraPackages = with pkgs; [
        ripgrep
      ];
      plugins = with pkgs.vimPlugins; [
        lazy-nvim
      ];
      extraLuaConfig =
        let
          mkEntryFromDrv =
            drv:
            if lib.isDerivation drv then
              {
                name = "${lib.getName drv}";
                path = drv;
              }
            else
              drv;
          lazyPath = pkgs.linkFarm "lazy-plugins" (
            # builtins.map mkEntryFromDrv (lib.subtractLists cfg.excludePlugins cfg.plugins ++ cfg.extraPlugins)
            builtins.map mkEntryFromDrv (cfg.plugins ++ cfg.extraPlugins)
          );
        in
        ''
          vim.g.mapleader = " "
          require("lazy").setup({
              defaults = {
                  lazy = true;
              },
              dev = {
                  path = "${lazyPath}",
                  patterns = { "." },
                  fallback = true,
              },
              spec = {
                  { import = "plugins" },
                  ${cfg.extraSpec}
              },
          })
          require("config")
          vim.cmd([[ colorscheme ${cfg.colorscheme} ]])
        '';
    };
    xdg.configFile."nvim/lua" = {
      recursive = true;
      source = ./lua;
    };
  };
}
