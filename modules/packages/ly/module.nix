{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.dawn) ly;
in {
  options.dawn.ly.enable = mkEnableOption "Enables the Ly display manager";

  config = mkIf ly.enable {
    services.displayManager.ly = {
      enable = true;
      settings = {
        animation = "matrix";
        box_title = "NixOS - Dawn";
      };
    };
  };
}
