{ ... }:
{
  flake.modules.homeManager.jujutsu =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      cfg = config.jujutsu-mod;
    in
    {
      options.jujutsu-mod = {
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
        signing-backend = lib.mkOption {
          type = lib.types.str;
          default = "none";
          description = "Enable git commit and tag signing, set to none to disable signing";
        };
      };

      config.programs.jujutsu = {
        enable = true;
        settings = {
          user = {
            name = cfg.username;
            email = cfg.email;
          };
          signing = {
            behavior = "drop";
            backend = cfg.signing-backend;
            key = cfg.signing-key;
          };
          git = {
            sign-on-push = true;
          };
          aliases = {
            lsig = [
              "log"
              "-T"
              "commit_id.short() ++ \" \" ++ if(signature, signature.status() ++ \" \" ++ signature.key(), \"unsigned\") ++ \" \" ++ description.first_line() ++ \"\\n\""
            ];
            ci = [
              "commit"
            ];
            ps = [
              "git"
              "push"
            ];
          };
          ui.diff-formatter = "delta";
          merge-tools.delta = {
            program = "sh";
            diff-args = [
              "-c" # sh
              ''
                if [ "$3" -gt 180 ]; then
                  exec delta --side-by-side "$1" "$2" --width="$3"
                else
                  exec delta --features=one-window "$1" "$2" --width="$3"
                fi
              ''
              "_"
              "$left"
              "$right"
              "$width"
            ];
            # Fixes `tool exited with exit status: 1` warning
            diff-expected-exit-codes = [
              0
              1
            ];
          };
        };
      };
    };
}
