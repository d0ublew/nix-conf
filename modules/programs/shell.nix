{ inputs, ... }:
let
  commonAliases = {
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
    ".." = "cd ..";
  };
in
{
  flake.modules.homeManager.shell =
    { pkgs, ... }:
    {
      programs.bash = {
        enable = true;
        enableCompletion = true;
        shellAliases = commonAliases;
        profileExtra = ''
          export PATH="''${HOME}/.local/bin:$PATH"
        '';
        bashrcExtra = ''
          source <(${pkgs.fzf}/bin/fzf --bash)
        '';
      };
    };
}
