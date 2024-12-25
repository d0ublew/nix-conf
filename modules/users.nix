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
    extraGroups = [
      "wheel"
      "podman-root"
    ];
  };
  users.groups."podman-root".gid = 10;
}
