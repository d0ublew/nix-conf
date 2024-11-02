{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  mod = "yazi-mod";
  cfg = config.${mod};
  yazi-plugins = pkgs.fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "ad52adf917d6dd679dbc2dcefa3a9384654bd1c7";
    hash = "sha256-UOSH8RM+6VkQqi14bwUdFUNm8CgbDRlNial9VevjYuU=";
    # hash = lib.fakeHash;
  };
in
{
  options.${mod} = {
    enable = mkEnableOption "yazi config";
  };

  config = mkIf cfg.enable {
    xdg.configFile."yazi/plugins/smart-enter.yazi/init.lua".text = ''
      return {
        entry = function()
          local h = cx.active.current.hovered
          ya.manager_emit(h and h.cha.is_dir and "enter" or "open", { hovered = true })
        end,
      }
    '';
    programs.yazi = {
      enable = true;
      enableBashIntegration = true;
      initLua = ./init.lua;
      settings = {
        manager = {
          show_hidden = true;
        };
        preview = {
          max_width = 2048;
          max_height = 2048;
        };
      };
      plugins = {
        full-border = "${yazi-plugins}/full-border.yazi";
        max-preview = "${yazi-plugins}/max-preview.yazi";
        hide-preview = "${yazi-plugins}/hide-preview.yazi";
      };
      keymap = {
        manager.prepend_keymap = [
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
            run = "plugin --sync smart-enter";
            on = [ "<Enter>" ];
            desc = "Enter the child directory, or open the file";
          }
          {
            run = "plugin --sync hide-preview";
            on = [ "<A-Z>" ];
            desc = "Toggle preview pane";
          }
          {
            run = "plugin --sync max-preview";
            on = [ "<A-p>" ];
            desc = "Maximize or restore preview";
          }
        ];
      };
    };
  };
}
