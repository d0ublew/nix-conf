{
  config,
  pkgs,
  uname,
  lib,
  unfree-pkgs,
  nixgl,
  ...
}:
let
  aliases = {
    # ls = "lsd";
    tree = "lsd --tree";
    less = "less -R";
    vim = "nvim";
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
    podr = "podman --remote";
  };
in
{
  nixGL.packages = import nixgl { inherit pkgs; };
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) unfree-pkgs;
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = uname;
  home.homeDirectory = "/home/${uname}";

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
  home.packages = with pkgs; [
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
    # colima
    # docker-client
    # docker-buildx
    # docker-compose
    # netcat-openbsd

    # nmap
    # feroxbuster
    # ldeep
    # smbclient-ng
    # coercer
    # bloodhound-py
    # certipy

    # gef-bata24
    # kompose
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".Xmodmap".source = ../modules/dotfiles/Xmodmap;
    ".inputrc".source = ../modules/dotfiles/inputrc;
    ".tmux".source = ../modules/dotfiles/tmux/tmux;
    ".tmux.conf".source = ../modules/dotfiles/tmux/tmux.conf;
    # ".wezterm.sh".source = ../modules/dotfiles/wezterm.sh;
    # ".docker/cli-plugins/docker-buildx".source = "${pkgs.docker-buildx}/bin/docker-buildx";

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
  # xdg.configFile."wtf/config.yml".source = ../modules/dotfiles/wtf/config.yml;
  xdg.configFile."ghostty/config".source = ../modules/dotfiles/ghostty/config;

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
    delta = true;
    username = uname;
    email = "66501624+d0UBleW@users.noreply.github.com";
  };

  neovim-mod = rec {
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
      javascript.enable = true;
      c.enable = true;
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

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = aliases;
    bashrcExtra = ''
      __tmux_prompt_hook() {
        PS0="${"$"}{TMUX:+\e]133;C\e\\}"
      }
      export PS1="[\u@\h \w]\n$ "
      # export PS1="[\u@\h \w]\n${"$"}{TMUX:+\e]133;A\e\\}> "
      # . $HOME/.wezterm.sh
      source <(${pkgs.fzf}/bin/fzf --bash)
      # source <(podman completion bash)
      # complete -o default -F __start_podman podr
      # [[ $DISPLAY ]] && xmodmap ~/.Xmodmap 2>/dev/null
    '';
    profileExtra = ''
      export PATH="${"$"}{HOME}/.local/bin:$PATH"
      export PROMPT_COMMAND="__tmux_prompt_hook;${"$"}{PROMPT_COMMAND}"
      # export LD_LIBRARY_PATH=/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH
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
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  programs.lsd = {
    enable = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
