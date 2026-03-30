{ inputs, ... }:
{
  flake.modules.homeManager.system-cli =
    { ... }:
    {
      imports = with inputs.self.modules.homeManager; [
        system-default
        starship
        git
        neovim
      ];

      home.file = {
        ".tmux".source = ../../dotfiles/tmux/tmux;
        ".tmux.conf".source = ../../dotfiles/tmux/tmux.conf;
      };

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
