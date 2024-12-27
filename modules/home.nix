{
  config,
  pkgs,
  uname,
  lib,
  ...
}:
let
  aliases = {
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
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "${uname}";
  home.homeDirectory = "/home/${uname}";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    uv
    patchelf
    gef-bata24
    kompose
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
    ".inputrc".source = dotfiles/inputrc;
    ".tmux".source = dotfiles/tmux/tmux;
    ".tmux.conf".source = dotfiles/tmux/tmux.conf;
    ".wezterm.sh".source = dotfiles/wezterm.sh;

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
  xdg.configFile."wtf/config.yml".source = dotfiles/wtf/config.yml;

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
    ./hm
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
      json.enable = true;
    };
    telescope.enable = true;
    completion.enable = true;
    ui.enable = true;
    misc.enable = true;
    mini.enable = true;
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
      . $HOME/.wezterm.sh
      source <(${pkgs.fzf}/bin/fzf --bash)
      source <(podman completion bash)
      complete -o default -F __start_podman podr
    '';
    profileExtra = ''
      export PATH="${"$"}{HOME}/.local/bin:$PATH"
      # export PROMPT_COMMAND="__tmux_prompt_hook;${"$"}{PROMPT_COMMAND}"
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

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
