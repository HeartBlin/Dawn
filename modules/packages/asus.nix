{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.dawn) asus;
in {
  options.dawn.asus.enable = mkEnableOption "Enables ASUS support";
  
  config = mkIf asus.enable {
    systemd.services.supergfxd.path = [ pkgs.pciutils ];
    services = {
      supergfxd.enable = true;
      asusd = {
        enable = true;
        enableUserService = true;
      };
    };
  };
}
