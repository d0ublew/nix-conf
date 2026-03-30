{ inputs, config, ... }:
{
  flake.homeConfigurations."williamwijaya" = config.flake.lib.mkStandaloneHome {
    system = "aarch64-darwin";
    stateVersion = "25.05";
    extraModules = [
      inputs.self.modules.homeManager.nix-settings
      inputs.self.modules.homeManager.lsd
      inputs.self.modules.homeManager.uv
      ({ pkgs, ... }: {
        imports = with inputs.self.modules.homeManager; [
          system-cli
        ];

        home.username = "williamwijaya";
        home.homeDirectory = "/Users/williamwijaya";

        nix.settings.trusted-users = [
          "root"
          "williamwijaya"
        ];

        home.packages =
          with pkgs;
          [
            gh
            fd
            p7zip
            tmux
            btop
            timg
            inetutils
            socat
            colima
            openjdk21
            radare2
            zoxide
            ripgrep
            ffmpeg
            dust
            iproute2mac
            wget
            fzf
            yarn
            xz
            reattach-to-user-namespace
            nodejs
            docker-client
            docker-buildx
            docker-compose
            zlib-ng
            nix-index
            rlwrap
            qemu
            nuclei
            semgrep
            parallel
            proxychains-ng
            gnupg
            nix-du
            nix-tree
            foundry
            simple-http-server
            mkcert
            dnsmasq
            bun
            zbar
            postgresql
            go
            pnpm
          ]
          ++ (with inputs.nixpkgs-stable.legacyPackages.${pkgs.stdenv.hostPlatform.system}; [
            tealdeer
            aria2
          ]);

        home.file.".docker/cli-plugins/docker-buildx".source = "${pkgs.docker-buildx}/bin/docker-buildx";

        git-mod = {
          username = "williamwijaya";
          signing-key = "C290D836F2395167";
          enable-signing = true;
        };

        neovim-mod = {
          package = pkgs.neovim-unwrapped;
          lsp = {
            java.enable = true;
            kotlin.enable = true;
            nim.enable = true;
            go.enable = true;
            dart.enable = true;
            c.enable = true;
            swift.enable = true;
            copilot.enable = true;
            svelte.enable = true;
            tailwindcss.enable = true;
          };
          snacks.enable = true;
          treesitter.enable = true;
          trouble.enable = true;
        };

        programs.bash.profileExtra = ''
          export PATH="''${HOME}/bin:$PATH"
          export PATH="''${HOME}/tools/jadx/bin:$PATH"

          export ANDROID_NDK_ROOT="''${HOME}/Library/Android/sdk/ndk/27.0.12077973/"
          export ANDROID_SDK_ROOT="''${HOME}/Library/Android/sdk"
          export ANDROID_HOME="''${HOME}/Library/Android/sdk"

          export PATH="''${ANDROID_SDK_ROOT}/platform-tools:$PATH"
          export PATH="''${ANDROID_SDK_ROOT}/emulator:$PATH"
          export PATH="''${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:$PATH"

          export PATH="''${ANDROID_NDK_ROOT}:$PATH"
          export LANG=en_US.UTF-8
        '';
        programs.bash.bashrcExtra = ''
          export PS1="[\u@\h \w]\n$ "
          [[ -f ~/tools/ipsw/completions/ipsw/_bash ]] && source ~/tools/ipsw/completions/ipsw/_bash

          FZF_CTRL_T_COMMAND="" eval "$(fzf --bash)"
          _fzf_setup_completion path cp mv cat

          M_GHOSTTY_BASH_INTEGRATION="''${GHOSTTY_RESOURCES_DIR}/shell-integration/bash/ghostty.bash"
          test -e "''${M_GHOSTTY_BASH_INTEGRATION}"  && source "''${M_GHOSTTY_BASH_INTEGRATION}"

          eval "$(/opt/homebrew/bin/brew shellenv)"
        '';

        programs.starship.enable = false;
        programs.command-not-found.enable = false;
      })
    ];
  };
}
