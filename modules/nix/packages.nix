{ inputs, ... }:
let
  packagesDir = ../../packages;
  packageNames = builtins.attrNames (
    inputs.nixpkgs.lib.filterAttrs (
      name: type: type == "directory" && builtins.pathExists (packagesDir + "/${name}/package.nix")
    ) (builtins.readDir packagesDir)
  );
in
{
  perSystem =
    { pkgs, ... }:
    {
      packages = builtins.listToAttrs (
        map (name: {
          inherit name;
          value = import (packagesDir + "/${name}/package.nix") { inherit pkgs; };
        }) packageNames
      );
    };
}
