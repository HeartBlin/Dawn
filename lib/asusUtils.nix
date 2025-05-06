{ lib, pkgs }:

let
  inherit (lib) concatMapStringsSep elemAt length range;

  asusKbdLedManagerScript = pkgs.writeShellScriptBin "asusKbdLedManager" ''
    set -euo pipefail

    action="''${1:-}"
    current=$(${pkgs.asusctl}/bin/asusctl -k | grep -oP 'Current keyboard led brightness: \K\w+')

    case "$action" in
      up)
        case "$current" in
          High)   exit 0;;  # Already at max
          *)      exec ${pkgs.asusctl}/bin/asusctl -n;;  # Increase normally
        esac
        ;;
      down)
        case "$current" in
          Off)    exit 0;;  # Already at min
          *)      exec ${pkgs.asusctl}/bin/asusctl -p;;  # Decrease normally
        esac
        ;;
      *)
        echo "Usage: $0 [up|down]" >&2
        exit 1
        ;;
    esac
  '';
in rec {
  inherit asusKbdLedManagerScript;

  generateLedChangeScript = { colors }: if length colors != 4 then
    throw "asusUtils.generateLedChangeScript: Expected 4 colors, got ${length colors}"
  else concatMapStringsSep "\n" (idx: let
    color = elemAt colors idx;
    zone = idx + 1;
  in "${pkgs.asusctl}/bin/asusctl aura static -z ${toString zone} -c ${color}") (range 0 3);

  mkLedChangeScript = { name ? "ledChange", colors }:
    pkgs.writeShellScriptBin name (generateLedChangeScript { inherit colors; });
}
