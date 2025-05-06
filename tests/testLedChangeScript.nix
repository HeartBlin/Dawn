{ lib, pkgs }:

let
  asusUtils = import ../lib/asusUtils.nix { inherit lib pkgs; };
  sampleColors = [ "FF0000" "00FF00" "0000FF" "FFFFFF" ];
in {
  expected = ''${pkgs.asusctl}/bin/asusctl aura static -z 1 -c FF0000
${pkgs.asusctl}/bin/asusctl aura static -z 2 -c 00FF00
${pkgs.asusctl}/bin/asusctl aura static -z 3 -c 0000FF
${pkgs.asusctl}/bin/asusctl aura static -z 4 -c FFFFFF'';

  expr = asusUtils.generateLedChangeScript { colors = sampleColors; };
}
