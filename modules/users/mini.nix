{ inputs, config, ... }:
{
  flake.homeConfigurations."mini" = config.flake.lib.mkStandaloneHome {
    system = "x86_64-linux";
    stateVersion = "25.05";
    extraSpecialArgs = {
      nixgl = inputs.nixgl;
    };
    extraModules = [
      inputs.self.modules.homeManager.nix-settings
      inputs.self.modules.homeManager.lsd
      ({ pkgs, config, ... }: {
        imports = with inputs.self.modules.homeManager; [
          system-cli
        ];

        home.username = "kali";
        home.homeDirectory = "/home/kali";

        nixGL.packages = import inputs.nixgl { inherit pkgs; };

        home.packages =
          with pkgs;
          [
            (config.lib.nixGL.wrap ghostty)

            uv
            gh
            ripgrep
            dust
            lsd
            python313
            fd
            aria2
            fzf
            socat
            tealdeer
            rlwrap
            p7zip
            btop
          ];

        home.file.".Xmodmap".source = ../dotfiles/Xmodmap;
        xdg.configFile."ghostty/config".source = ../dotfiles/ghostty/config;

        git-mod.username = "kali";

        neovim-mod.lsp.c.enable = true;
        neovim-mod.snacks.enable = true;
        neovim-mod.treesitter.enable = true;
        neovim-mod.trouble.enable = true;

        programs.bash.shellAliases = {
          podr = "podman --remote";
        };
        programs.bash.bashrcExtra = ''
          __tmux_prompt_hook() {
            PS0="''${TMUX:+\e]133;C\e\\}"
          }
          export PS1="[\u@\h \w]\n$ "
        '';
        programs.bash.profileExtra = ''
          export PROMPT_COMMAND="__tmux_prompt_hook;''${PROMPT_COMMAND}"
        '';

        programs.lsd.enableBashIntegration = false;
        programs.lsd.icons = false;
        programs.lsd.colors = false;
      })
    ];
  };
}
