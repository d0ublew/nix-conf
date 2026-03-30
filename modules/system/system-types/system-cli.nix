{ inputs, ... }:
{
  flake.modules.homeManager.system-cli =
    { lib, pkgs, ... }:
    {
      imports = with inputs.self.modules.homeManager; [
        system-default
        starship
        git
        neovim
      ];

      home.file = lib.mkMerge [
        (lib.mkIf pkgs.stdenv.isDarwin {
          ".tmux".source = ../../dotfiles/tmux/darwin/tmux;
          ".tmux.conf".source = ../../dotfiles/tmux/darwin/tmux.conf;
        })
        (lib.mkIf pkgs.stdenv.isLinux {
          ".tmux".source = ../../dotfiles/tmux/linux/tmux;
          ".tmux.conf".source = ../../dotfiles/tmux/linux/tmux.conf;
        })
      ];

      git-mod.email = "66501624+d0UBleW@users.noreply.github.com";

      neovim-mod = rec {
        enable = true;
        colorschemes = [
          "tokyonight"
          "rose-pine"
        ];
        colorscheme = builtins.elemAt colorschemes 0;
        lsp = {
          enable = true;
          nix.enable = true;
          lua.enable = true;
          python.enable = true;
          javascript.enable = true;
          json.enable = true;
        };
        telescope.enable = true;
        completion.enable = true;
        ui.enable = true;
        misc.enable = true;
        mini.enable = true;
      };
    };
}
