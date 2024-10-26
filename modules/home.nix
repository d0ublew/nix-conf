{
  config,
  pkgs,
  uname,
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
  home.packages = [
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
    EDITOR = "${pkgs.neovim}/bin/nvim";
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = aliases;
    # bashrcExtra = ''
    # eval "$(zoxide init bash)"
    # '';
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
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

  programs.git = {
    enable = true;
    userName = "d0ublew";
    userEmail = "66501624+d0UBleW@users.noreply.github.com";
    delta = {
      enable = true;
      options = {
        navigate = true;
        light = false;
        line-numbers = false;
      };
    };
    extraConfig = {
      "credential \"https://github.com\"".helper = "!${pkgs.gh}/bin/gh auth git-credential";
      "credential \"https://gist.github.com\"".helper = "!${pkgs.gh}/bin/gh auth git-credential";
      core = {
        editor = "${pkgs.neovim}/bin/nvim";
      };
      init.defaultBranch = "main";
      diff.tool = "${pkgs.neovim}/bin/nvim -d";
      difftool.prompt = false;
    };
    aliases = {
      ap = "add -i -p";
      st = "status";
      sw = "switch";
      br = "branch";
      ba = "branch -a";
      d = "diff";
      ci = "commit";
      ca = "commit -a";
      rb = "rebase";
      wt = "worktree";
      fh = "fetch";
      ps = "!${pkgs.git}/bin/git push -u origin $(git rev-parse --abbrev-ref HEAD)";
      pl = "!${pkgs.git}/bin/git pull origin $(git rev-parse --abbrev-ref HEAD)";
      hist = "log --pretty=format:\"%Cgreen%h %Creset%cd %Cblue[%cn] %Creset%s%C(yellow)%d%C(reset)\" --graph --date=relative --decorate --all";
      logg = "log --pretty=format:\"%Cgreen%h %Creset%cd %Cblue[%cn] %Creset%s%C(yellow)%d%C(reset)\" --date=relative --decorate";
      llog = "log --graph --name-status --pretty=format:\"%C(red)%h %C(reset)(%cd) %C(green)%an %Creset%s %C(yellow)%d%Creset\" --date=relative";
    };
  };

  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
