{ ... }:
{
  flake.modules.homeManager.yazi =
    { pkgs, lib, ... }:
    let
      yazi-plugins = pkgs.fetchFromGitHub {
        owner = "yazi-rs";
        repo = "plugins";
        rev = "8cd50c622898d3ace3ca821f540241965308289a";
        hash = "sha256-f4y952sUF/lrHMX6enQts/obk2DeatqAcaVHfjTD65k=";
      };
    in
    {
      programs.yazi = {
        enable = true;
        enableBashIntegration = true;
        initLua = ./_yazi/init.lua;
        flavors = {
          tokyonight-day = ./_yazi/flavors/tokyonight-day;
          tokyonight-moon = ./_yazi/flavors/tokyonight-moon;
        };
        theme = {
          flavor = {
            light = "tokyonight-day";
            dark = "tokyonight-moon";
          };
        };
        settings = {
          mgr = {
            show_hidden = true;
          };
          preview = {
            max_width = 2048;
            max_height = 2048;
          };
        };
        plugins = {
          full-border = "${yazi-plugins}/full-border.yazi";
          toggle-pane = "${yazi-plugins}/toggle-pane.yazi";
          smart-enter = "${yazi-plugins}/smart-enter.yazi";
        };
        keymap = {
          mgr.prepend_keymap = [
            {
              run = "leave";
              on = [ "-" ];
              desc = "Go back to parent directory";
            }
            {
              run = "link";
              on = [ "_" ];
              desc = "Symlink the absolute path of yanked files";
            }
            {
              run = "seek -5";
              on = [ "<A-u>" ];
              desc = "Seek up 5 units in the preview";
            }
            {
              run = "seek 5";
              on = [ "<A-d>" ];
              desc = "Seek down 5 units in the preview";
            }
            {
              run = "cd ~/ws";
              on = [
                "g"
                "p"
              ];
              desc = "Go to the workspace directory";
            }
            {
              run = "plugin smart-enter";
              on = [ "<Enter>" ];
              desc = "Enter the child directory, or open the file";
            }
            {
              run = "plugin toggle-pane min-preview";
              on = [ "<A-Z>" ];
              desc = "Toggle preview pane";
            }
            {
              run = "plugin toggle-pane max-preview";
              on = [ "<A-p>" ];
              desc = "Maximize or restore preview";
            }
          ];
        };
      };
    };
}
