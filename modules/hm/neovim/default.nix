{
  config,
  pkgs-stable,
  lib,
  ...
}:
with lib;
let
  mod = "neovim-mod";
  cfg = config.${mod};
  cschemes = [
    "default"
    "tokyonight"
    "rose-pine"
  ];
in
{

  imports = lib.my.getModules ./.;

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
      colorschemesOptionType =
        let
          inherit (lib.types)
            listOf
            oneOf
            enum
            ;
        in
        oneOf [
          (enum cschemes)
          (listOf (enum cschemes))
        ];
    in
    {
      enable = mkEnableOption "Neovim config";
      plugins = mkOption {
        type = pluginsOptionType;
        default = with pkgs-stable.vimPlugins; [
          # lazy-nvim
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
        type = lib.types.enum cschemes;
        default = "default";
        description = "Enabled colorscheme from list of installed colorschemes";
      };

      colorschemes = mkOption {
        type = colorschemesOptionType;
        default = cschemes;
        description = "List of colorschemes to be installed";
      };

      package = mkOption {
        type = lib.types.package;
        default = pkgs-stable.neovim-unwrapped;
        description = "Neovim package to be used";
      };
    };

  # https://github.com/LazyVim/LazyVim/discussions/1972
  config = mkIf cfg.enable {
    programs.neovim = {
      package = cfg.package;
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      withNodeJs = false;
      extraPackages = with pkgs-stable; [
        ripgrep
      ];
      plugins = with pkgs-stable.vimPlugins; [
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
          lazyPath = pkgs-stable.linkFarm "lazy-plugins" (
            # builtins.map mkEntryFromDrv (lib.subtractLists cfg.excludePlugins cfg.plugins ++ cfg.extraPlugins)
            builtins.map mkEntryFromDrv (cfg.plugins ++ cfg.extraPlugins)
          );
        in
        ''
          vim.g.mapleader = " "
          vim.g.maplocalleader = ","
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
                  ${cfg.extraSpec}
                  { import = "plugins" },
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
    xdg.configFile."nvim/after/ftplugin" = {
      recursive = true;
      source = ./ftplugin;
    };
  };
}
