{
  pkgs,
  lib,
  config,
  inputs,
  uname,
  ...
}: {
  imports = [
    ./packages.nix
  ];
  wsl = {
    enable = true;
    defaultUser = "${uname}";
    docker-desktop.enable = false;
  };

  users.users."${uname}" = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  # home-manager = {
  #   extraSpecialArgs = { inherit uname; };
  #   users = {
  #     "${uname}" = import ./home.nix;
  #   };
  # };
}
