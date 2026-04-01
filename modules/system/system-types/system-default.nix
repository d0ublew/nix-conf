{ inputs, ... }:
{
  flake.modules.homeManager.system-default = {
    imports = with inputs.self.modules.homeManager; [
      shell
      bat
      delta
      direnv
      zoxide
      overlays
      yazi
      unfree-pkgs
    ];

    programs.home-manager.enable = true;
    home.file.".inputrc".source = ../../dotfiles/inputrc;
  };
}
