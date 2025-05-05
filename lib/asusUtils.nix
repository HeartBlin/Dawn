{ lib, pkgs }:

let
  inherit (lib) concatMapStringsSep elemAt length range;
in rec {
  generateLedChangeScript = { colors }: if length colors != 4 then
    throw "asusUtils.generateLedChangeScript: Expected 4 colors, got ${length colors}"
  else concatMapStringsSep "\n" (idx: let
    color = elemAt colors idx;
    zone = idx + 1;
  in "${pkgs.asusctl}/bin/asusctl aura static -z ${toString zone} -c ${color}") (range 0 3);

  mkLedChangeScript = { name ? "ledChange", colors }:
    pkgs.writeShellScriptBin name (generateLedChangeScript { inherit colors; });
}