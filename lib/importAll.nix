{ lib }:

let
  inherit (lib) flatten;
  inherit (builtins) readDir mapAttrs filter attrValues;

  importAll = dirPath: let
    dirContents = readDir dirPath;
    processedEntries = mapAttrs (name: type: let
      fullPath = dirPath + "/${name}";
    in if type == "directory" then
      importAll fullPath
    else if type == "regular" && name == "module.nix" then
      import fullPath
    else null) dirContents;

    modules = filter (x: x != null) (attrValues processedEntries);
    flattenedModules = flatten modules;
  in flattenedModules;
in importAll
