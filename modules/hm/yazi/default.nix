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
    rev = "273019910c1111a388dd20e057606016f4bd0d17";
    hash = "sha256-80mR86UWgD11XuzpVNn56fmGRkvj0af2cFaZkU8M31I=";
    # hash = lib.fakeHash;
  };
in
{
  options.${mod} = {
    enable = mkEnableOption "yazi config";
  };

  config = mkIf cfg.enable {
    # xdg.configFile."yazi/plugins/smart-enter.yazi/init.lua".text = ''
    #   return {
    #     entry = function()
    #       local h = cx.active.current.hovered
    #       ya.manager_emit(h and h.cha.is_dir and "enter" or "open", { hovered = true })
    #     end,
    #   }
    # '';
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
        smart-enter = "${yazi-plugins}/smart-enter.yazi";
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
            run = "plugin smart-enter";
            on = [ "<Enter>" ];
            desc = "Enter the child directory, or open the file";
          }
          {
            run = "plugin hide-preview";
            on = [ "<A-Z>" ];
            desc = "Toggle preview pane";
          }
          {
            run = "plugin max-preview";
            on = [ "<A-p>" ];
            desc = "Maximize or restore preview";
          }
        ];
      };
    };
  };
}
