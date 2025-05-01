{ config,dawn, inputs', lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.dawn) steam;
  inherit (dawn) userName;
in {
  options.dawn.steam.enable = mkEnableOption "Enables Steam";
  
  config = mkIf steam.enable {
    users.users.${userName}.packages = [ 
      inputs'.umu.packages.default
      pkgs.protontricks  
    ];

    programs = {
      steam = {
        enable = true;
        extraCompatPackages = [ pkgs.proton-ge-bin ];
        gamescopeSession.enable = true;
      };

      gamescope = {
        enable = true;
        capSysNice = true;
        args = [ "--rt" "--expose-wayland" ];
      };
    };
  };
}
