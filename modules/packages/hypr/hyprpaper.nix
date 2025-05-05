{ config, dawn, inputs', lib, ... }:

let
  inherit (lib) mkIf;
  inherit (config.dawn) hyprland;
  inherit (dawn.hyprUtils) mkHyprWallpapers;

  settings = ''
    ${mkHyprWallpapers hyprland.wallpapers}
    splash = false
    ipc = false
  '';  
in {
  config = mkIf hyprland.enable {
    environment.systemPackages = [
      inputs'.hyprpaper.packages.hyprpaper
    ];

    homix.".config/hypr/hyprpaper.conf".text = settings;
  };
}