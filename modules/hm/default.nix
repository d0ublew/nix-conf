{ lib, ... }:
{
  imports = lib.my.getModules ./.;
}
