{
  config,
  pkgs,
  uname,
  lib,
  unfree-pkgs,
  pkgs-stable,
  ...
}:
let
  aliases = {
    less = "less -R";
    # vim = "nvim";
    tm = "history -a; tmux";
    ta = "tmux attach";
    py3 = "python3";
    cat = "bat";
    c = "clear";
    g = "git";
    rm = "rm -i";
    mv = "mv -i";
    cp = "cp -i";
    ".." = "cd ..";
    tree = "lsd --tree";
    ascii = "rax2 -a";
  };
in
{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) unfree-pkgs;
  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        "williamwijaya"
      ];
      extra-substituters = [ "https://nix-community.cachix.org" ];
      extra-trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];

    };
  };
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "${uname}";
  home.homeDirectory = "/Users/${uname}";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages =
    with pkgs;
    [
      # cachix
      # ascii
      gh
      fd
      p7zip
      tmux
      btop
      timg
      # devenv
      inetutils
      socat
      colima
      openjdk21
      # kotlin
      radare2
      zoxide
      ripgrep
      ffmpeg
      dust
      iproute2mac
      aria2
      wget
      fzf
      # scrcpy
      yarn
      # tealdeer
      xz
      reattach-to-user-namespace
      # nodejs
      docker-client
      docker-buildx
      docker-compose
      zlib-ng
      nix-index
      rlwrap
      # gemini-cli
      qemu
      nuclei
      semgrep
      # powershell
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
      deno

      # gef-bata24

      # aapt
      # apksigner
      # apktool
    ]
    ++ (with pkgs-stable; [
      tealdeer
    ]);

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".inputrc".source = ../modules/dotfiles/inputrc;
    # ".tmux".source = ../modules/dotfiles/tmux/tmux;
    # ".tmux.conf".source = ../modules/dotfiles/tmux/tmux.conf;
    # ".wezterm.sh".source = ../modules/dotfiles/wezterm.sh;
    ".docker/cli-plugins/docker-buildx".source = "${pkgs.docker-buildx}/bin/docker-buildx";

    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };
  # xdg.configFile."wtf/config.yml".source = dotfiles/wtf/config.yml;

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/d0ublew/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
    # EDITOR = "${pkgs.neovim}/bin/nvim";
  };

  imports = [
    ../modules/hm
  ];

  git-mod = {
    enable = true;
    username = uname;
    email = "66501624+d0UBleW@users.noreply.github.com";
    signing-key = "C290D836F2395167";
    enable-signing = true;
  };

  neovim-mod = rec {
    package = pkgs.neovim-unwrapped;
    enable = true;
    colorschemes = [
      "tokyonight"
      "rose-pine"
    ];
    colorscheme = lib.elemAt colorschemes 0;
    lsp = {
      enable = true;
      nix.enable = true;
      lua.enable = true;
      python.enable = true;
      json.enable = true;
      javascript.enable = true;
      java.enable = true;
      kotlin.enable = true;
      nim.enable = true;
      go.enable = true;
      dart.enable = true;
      c.enable = true;
      swift.enable = true;
    };
    telescope.enable = true;
    completion.enable = true;
    ui.enable = true;
    misc.enable = true;
    mini.enable = true;
    snacks.enable = true;
    treesitter.enable = true;
    trouble.enable = true;
  };

  yazi-mod = {
    enable = true;
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      light = true;
      line-numbers = false;
    };
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = aliases;
    profileExtra = ''
      export PATH="${"$"}{HOME}/.local/bin:$PATH"
      export PATH="${"$"}{HOME}/bin:$PATH"
      export PATH="${"$"}{HOME}/tools/jadx/bin:$PATH"

      export ANDROID_NDK_ROOT="${"$"}{HOME}/Library/Android/sdk/ndk/27.0.12077973/"
      # export ANDROID_NDK_ROOT="${"$"}{HOME}/Library/Android/sdk/ndk/28.1.13356709/"
      export ANDROID_SDK_ROOT="${"$"}{HOME}/Library/Android/sdk"
      export ANDROID_HOME="${"$"}{HOME}/Library/Android/sdk"

      export PATH="${"$"}{ANDROID_SDK_ROOT}/platform-tools:$PATH"
      export PATH="${"$"}{ANDROID_SDK_ROOT}/emulator:$PATH"
      export PATH="${"$"}{ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:$PATH"

      export PATH="${"$"}{ANDROID_NDK_ROOT}:$PATH"
      export LANG=en_US.UTF-8
    '';
    bashrcExtra = ''
      export PS1="[\u@\h \w]\n$ "
      [[ -f ~/tools/ipsw/completions/ipsw/_bash ]] && source ~/tools/ipsw/completions/ipsw/_bash

      FZF_CTRL_T_COMMAND="" eval "$(fzf --bash)"
      _fzf_setup_completion path cp mv cat

      M_GHOSTTY_BASH_INTEGRATION="${"$"}{GHOSTTY_RESOURCES_DIR}/shell-integration/bash/ghostty.bash"
      test -e "${"$"}{M_GHOSTTY_BASH_INTEGRATION}"  && source "${"$"}{M_GHOSTTY_BASH_INTEGRATION}"

      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';

    initExtra = ''
      # source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
    '';
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "ansi";
      style = "plain";
      paging = "never";
      pager = "less -FR";
    };
  };

  programs.direnv = {
    package = pkgs-stable.direnv;
    enable = true;
    enableBashIntegration = true;
    nix-direnv = {
      enable = true;
      package = pkgs.nix-direnv;
    };
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.lsd = {
    enable = true;
    enableBashIntegration = true;
    icons = true;
    colors = true;
  };

  programs.uv = {
    enable = true;
    settings = {
      python-preference = "managed";
    };
  };

  programs.command-not-found = {
    enable = false;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
