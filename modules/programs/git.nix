{ ... }:
{
  flake.modules.homeManager.git =
    { config, pkgs, lib, ... }:
    let
      cfg = config.git-mod;
    in
    {
      options.git-mod = {
        username = lib.mkOption {
          type = lib.types.str;
          description = "Git user name";
        };
        email = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Git user email";
        };
        signing-key = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Git user signing key";
        };
        enable-signing = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable git commit and tag signing";
        };
        default-branch = lib.mkOption {
          type = lib.types.str;
          default = "main";
          description = "Default git branch name";
        };
      };

      config.programs.git = {
        enable = true;
        signing = {
          key = cfg.signing-key;
          signByDefault = cfg.enable-signing;
        };
        settings = {
          user = {
            name = cfg.username;
            email = cfg.email;
          };
          alias = {
            ap = "add -i -p";
            st = "status";
            sw = "switch";
            br = "branch";
            ba = "branch -a";
            d = "diff";
            co = "checkout";
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
            submodule-checkout-branch = "!f() { git submodule -q foreach 'branch=$(git branch --no-column --format=\"%(refname:short)\" --points-at `git rev-parse HEAD` | grep -v \"HEAD detached\" | head -1); if [[ ! -z $branch && -z `git symbolic-ref --short -q HEAD` ]]; then git checkout -q \"$branch\"; fi'; }; f";
          };
          "credential \"https://github.com\"".helper = "!${pkgs.gh}/bin/gh auth git-credential";
          "credential \"https://gist.github.com\"".helper = "!${pkgs.gh}/bin/gh auth git-credential";
          core = {
            editor = "nvim";
            autocrlf = "input";
          };
          init.defaultBranch = cfg.default-branch;
          diff.tool = "nvim -d";
          difftool.prompt = false;
          pull.rebase = true;
          rebase.autoStash = true;
          submodule.recurse = true;
          push.followTags = true;
        };
      };
    };
}
