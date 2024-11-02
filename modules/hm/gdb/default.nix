{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  mod = "gdb-mod";
  cfg = config.${mod};
  bata24-gef = pkgs.fetchFromGitHub {
    owner = "d0ublew";
    repo = "gef";
    rev = "02e23a11adc4a3f5c4ef3f5a1f67845d390d8ceb";
    hash = "sha256-PmkmmH58m3mmsD5q/O03GwEKoH9hVy0BMi6VLrhVY94=";
    # hash = lib.fakeHash;
  };
in
{
  options.${mod} = {
    enable = mkEnableOption "GDB config";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      gdb
    ];
    home.file = {
      ".gef-bata24.rc".text = builtins.readFile "${bata24-gef}/gef-bata24.rc";
      ".gdbinit-gef-bata24.py".text = builtins.readFile "${bata24-gef}/gef.py";
    };
  };
}
