{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.dawn) asus;

  ledChange = pkgs.writeShellScriptBin "ledChange" ''
    ${pkgs.asusctl}/bin/asusctl aura static -z 1 -c 0066FF
    ${pkgs.asusctl}/bin/asusctl aura static -z 2 -c 00A69D
    ${pkgs.asusctl}/bin/asusctl aura static -z 3 -c 00E63B
    ${pkgs.asusctl}/bin/asusctl aura static -z 4 -c 00FF14
  '';
in {
  options.dawn.asus.enable = mkEnableOption "Enables ASUS support";
  
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
