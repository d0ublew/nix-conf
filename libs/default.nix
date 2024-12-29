{ lib }:
let
  readDirAbsolute =
    path:
    lib.attrsets.mapAttrs (name: type: {
      inherit type;
      abs = (builtins.toPath (path + "/${name}"));
    }) (builtins.readDir path);
in
{
  # getModulesEx =
  #   {
  #     path,
  #     exclude ? [ ],
  #   }:
  #   builtins.map (fname: (path + "/${fname}")) (
  #     lib.attrNames (
  #       lib.filterAttrs (
  #         name: _type:
  #         (!(builtins.elem name (builtins.map (e: builtins.baseNameOf e) exclude)))
  #         && ((_type == "directory") || ((name != "default.nix") && (lib.strings.hasSuffix ".nix" name)))
  #       ) (builtins.readDir path)
  #     )
  #   );

  getModules =
    path:
    builtins.map (fname: (path + "/${fname}")) (
      lib.attrNames (
        lib.filterAttrs (
          name: value:
          ((value.type == "directory") && (builtins.pathExists (value.abs + "/default.nix")))
          || ((name != "default.nix") && (lib.strings.hasSuffix ".nix" name))
        ) (readDirAbsolute path)
      )
    );
}
