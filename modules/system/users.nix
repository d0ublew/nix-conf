{ ... }:
let
  uname = "d0ublew";
in
{
  flake.modules.nixos.users = {
    users.users.${uname} = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "podman-root"
      ];
    };
    users.groups."podman-root".gid = 10;
  };
}
