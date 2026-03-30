{ inputs, config, ... }:
{
  flake.homeConfigurations."kali" = config.flake.lib.mkStandaloneHome {
    system = "x86_64-linux";
    stateVersion = "24.11";
    extraModules = [
      inputs.self.modules.homeManager.nix-settings
      inputs.self.modules.homeManager.lsd
      ({ pkgs, ... }: {
        imports = with inputs.self.modules.homeManager; [
          system-cli
        ];

        home.username = "kali";
        home.homeDirectory = "/home/kali";

        home.packages = with pkgs; [
          uv
          gh
          patchelf
          ripgrep
          dust
          python312
          fd
          aria2
          fzf

          nmap
          feroxbuster
          ldeep
          smbclient-ng
          coercer
          bloodhound-py
          certipy
        ];

        xdg.configFile."wtf/config.yml".source = ../dotfiles/wtf/config.yml;

        git-mod.username = "kali";

        programs.bash.shellAliases = {
          ls = "lsd";
          tree = "lsd --tree";
          podr = "podman --remote";
        };
        programs.bash.bashrcExtra = ''
          __tmux_prompt_hook() {
            PS0="''${TMUX:+\e]133;C\e\\}"
          }
        '';
        programs.bash.profileExtra = ''
          [[ $DISPLAY ]] && xmodmap ~/.Xmodmap
        '';

        programs.lsd.enableBashIntegration = false;
        programs.lsd.icons = false;
        programs.lsd.colors = false;
      })
    ];
  };
}
