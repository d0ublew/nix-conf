{ ... }:
{
  flake.modules.homeManager.gpg =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      cfg = config.gpg-mod;
    in
    {
      options.gpg-mod = {
        cache-ttl = lib.mkOption {
          type = lib.types.int;
          default = 3600;
          description = "gpg-agent default cache TTL (seconds)";
        };
        max-cache-ttl = lib.mkOption {
          type = lib.types.int;
          default = 7200;
          description = "gpg-agent max cache TTL (seconds)";
        };
      };

      config = lib.mkMerge [
        {
          programs.gpg = {
            enable = true;

            # public keys imported into keyring + ownertrust on activation
            publicKeys = [
              {
                source = ./gpg-keys/github-sign.asc;
                trust = "ultimate";
              }
              {
                source = ./gpg-keys/primary.asc;
                trust = "ultimate";
              }
              {
                source = ./gpg-keys/sonatype.asc;
                trust = "unknown";
              }
            ];

            settings = {
              keyid-format = "0xlong";
              with-fingerprint = true;
            };
          };
        }

        (lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
          services.gpg-agent = {
            enable = true;
            pinentry.package = pkgs.pinentry-curses;
            defaultCacheTtl = cfg.cache-ttl;
            maxCacheTtl = cfg.max-cache-ttl;
          };
        })

        (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
          home.packages = [ pkgs.pinentry_mac ];
          home.file.".gnupg/gpg-agent.conf".text = ''
            default-cache-ttl ${toString cfg.cache-ttl}
            max-cache-ttl ${toString cfg.max-cache-ttl}
            pinentry-program ${pkgs.pinentry_mac}/bin/pinentry-mac
          '';
        })
      ];
    };
}
