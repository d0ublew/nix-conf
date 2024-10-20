{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  imports = [
    ./aliases.nix
    ./packages.nix
    inputs.home-manager.nixosModules.default
  ];
  wsl = {
    enable = true;
    defaultUser = "d0ublew";
    docker-desktop.enable = false;
  };

  users.users.d0ublew = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  programs.bash.completion.enable = true;

  home-manager = {
    # extraSpecialArgs = { inherit inputs; };
    users = {
      "d0ublew" = import ./home.nix;
    };
  };
}
