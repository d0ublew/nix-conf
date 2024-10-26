{
  pkgs,
  lib,
  config,
  inputs,
  uname,
  ...
}:
{
  users.users."${uname}" = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
}
