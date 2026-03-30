{ ... }:
{
  flake.modules.homeManager.gdb =
    { pkgs, ... }:
    let
      bata24-gef = pkgs.fetchFromGitHub {
        owner = "d0ublew";
        repo = "gef";
        rev = "02e23a11adc4a3f5c4ef3f5a1f67845d390d8ceb";
        hash = "sha256-PmkmmH58m3mmsD5q/O03GwEKoH9hVy0BMi6VLrhVY94=";
      };
    in
    {
      home.packages = with pkgs; [
        gdb
      ];
      home.file = {
        ".gef-bata24.rc".text = builtins.readFile "${bata24-gef}/gef-bata24.rc";
        ".gdbinit-gef-bata24.py".text = builtins.readFile "${bata24-gef}/gef.py";
      };
    };
}
