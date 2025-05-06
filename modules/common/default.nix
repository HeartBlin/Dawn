{ dawn, ... }:

let
  inherit (dawn) importAll;
  allModules = importAll ./.;
in {
  imports = allModules;
}
