{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  mod = "git-mod";
  cfg = config.${mod};
in
{
  # TODO: shell alias 'g = git'
  options.${mod} = {
    enable = mkEnableOption "Git config";
    # TODO: group delta options
    delta = mkEnableOption "delta as diff";
    delta-light = mkEnableOption "delta light mode";
    username = mkOption {
      type = types.str;
      description = "Git user name";
    };
    email = mkOption {
      type = types.str;
      description = "Git user email";
    };
    default-branch = mkOption {
      type = types.str;
      default = "main";
      description = "Default git branch name";
    };
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = cfg.enable;
      userName = cfg.username;
      userEmail = cfg.email;
      delta = {
        enable = cfg.delta;
        options = {
          navigate = true;
          light = cfg.delta-light;
          line-numbers = false;
        };
      };
      extraConfig = {
        "credential \"https://github.com\"".helper = "!${pkgs.gh}/bin/gh auth git-credential";
        "credential \"https://gist.github.com\"".helper = "!${pkgs.gh}/bin/gh auth git-credential";
        core = {
          editor = "nvim";
        };
        init.defaultBranch = cfg.default-branch;
        diff.tool = "nvim -d";
        difftool.prompt = false;
        pull.rebase = true;
        rebase.autoStash = true;
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
  };
}
