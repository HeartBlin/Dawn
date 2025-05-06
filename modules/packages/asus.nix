{ config, dawn, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption;
  inherit (lib.types) listOf str;
  inherit (config.dawn) asus;
  inherit (dawn.asusUtils) mkLedChangeScript;

  defaultColors = [ "0066FF" "00A69D" "00E63B" "00FF14" ];
  ledChange = mkLedChangeScript {
    name = "ledChange";
    colors = asus.ledColors;
  };
in {
  options.dawn.asus = {
    enable = mkEnableOption "Enables ASUS support";
    ledColors = mkOption {
      type = listOf str;
      default = defaultColors;
      description = ''
        List of colors for the ASUS LEDs.
        Each color is a hex string without the leading #.
        Supports only the G513IE model currently, given it's 4 zones.
      '';
    };
  };

  config = mkIf asus.enable {
    services = {
      supergfxd.enable = true;
      asusd = {
        enable = true;
        enableUserService = true;
      };
    };

    systemd.services = {
      supergfxd.path = [ pkgs.pciutils ];
      forceLeds = {
        description = "Set colors for LEDs at boot";
        after = [ "asusd.service" "display-manager.service" ];
        wantedBy = [ "graphical.target" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${ledChange}/bin/ledChange";
        };
      };
    };
  };
}
