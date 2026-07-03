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
          aliases.lsig = [
            "log"
            "-T"
            "commit_id.short() ++ \" \" ++ if(signature, signature.status() ++ \" \" ++ signature.key(), \"unsigned\") ++ \" \" ++ description.first_line() ++ \"\\n\""
          ];
        };
      };
    };
}
