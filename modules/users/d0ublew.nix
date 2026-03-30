{ inputs, ... }:
{
  flake.modules.homeManager.d0ublew =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.homeManager; [
        system-cli
      ];

      home.username = "d0ublew";
      home.homeDirectory = "/home/d0ublew";

      home.packages = with pkgs; [
        uv
        patchelf
        gef-bata24
        kompose
        zrok
        ngrok
        devenv
      ];

      home.file.".wezterm.sh".source = ../dotfiles/wezterm.sh;
      xdg.configFile."wtf/config.yml".source = ../dotfiles/wtf/config.yml;

      git-mod.username = "d0ublew";

      neovim-mod.lsp.c.enable = true;
      neovim-mod.snacks.enable = true;
      neovim-mod.treesitter.enable = true;

      programs.bash.shellAliases.podr = "podman --remote";
      programs.bash.bashrcExtra = ''
        __tmux_prompt_hook() {
          PS0="''${TMUX:+\e]133;C\e\\}"
        }
        . $HOME/.wezterm.sh
        source <(podman completion bash)
        complete -o default -F __start_podman podr
      '';

      programs.direnv.stdlib = ''
        : "''${XDG_CACHE_HOME:="''${HOME}/.cache"}"
        declare -A direnv_layout_dirs
        direnv_layout_dir() {
            local hash path
            echo "''${direnv_layout_dirs[$PWD]:=$(
                hash="$(sha1sum - <<< "$PWD" | head -c40)"
                path="''${PWD//[^a-zA-Z0-9]/-}"
                echo "''${XDG_CACHE_HOME}/direnv/layouts/''${hash}''${path}"
            )}"
        }
      '';
    };
}
