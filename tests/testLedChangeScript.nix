{ lib, pkgs }:

let
  generateLedChangeScript = import ../lib/asusUtils.nix { inherit lib pkgs; }.generateLedChangeScript;
  sampleColors = [ "FF0000" "00FF00" "0000FF" "FFFFFF" ];
in {
  expected = ''${pkgs.asusctl}/bin/asusctl aura static -z 1 -c FF0000
${pkgs.asusctl}/bin/asusctl aura static -z 2 -c 00FF00
${pkgs.asusctl}/bin/asusctl aura static -z 3 -c 0000FF
${pkgs.asusctl}/bin/asusctl aura static -z 4 -c FFFFFF'';

  expr = generateLedChangeScript { colors = sampleColors; };
}
