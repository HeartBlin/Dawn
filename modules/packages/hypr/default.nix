{ config, inputs', lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption;
  inherit (lib.types) float int listOf path str submodule;
  inherit (config.dawn) hyprland;
in {
  imports = [ ./hyprland.nix ./hyprpaper.nix ];

  options.dawn.hyprland = {
    enable = mkEnableOption "Enables Hyprland";

    monitors = mkOption {
      description = "List of monitors";
      default = [];
      type = listOf (submodule {
        options = {
          name = mkOption {
            description = "Monitor name as given by Hyprland";
            type = str;
          };

          resolution = mkOption {
            description = "Monitor resolution (1920x1080)";
            type = str;
          };

          refreshRate = mkOption {
            description = "Monitor refresh rate (144)";
            type = int;
          };

          position = mkOption {
            description = "Position coordonates { x, y }";
            type = submodule {
              options = {
                x = mkOption { type = int; };
                y = mkOption { type = int; };
              };
            };
          };

          scale = mkOption {
            description = "Scaling factor (1.0)";
            type = float;
          };
        };
      });
    };

    wallpapers = mkOption {
      type = listOf (submodule {
        options = {
          monitor = mkOption {
            description = "Monitor name as configured";
            type = str;
          };

          wallpaper = mkOption {
            description = "Path to the wallpaper image file";
            type = path;
          };
        };
      });
    };
  };

  config = mkIf hyprland.enable {
    nix.settings = {
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };

    environment = {
      variables.NIXOS_OZONE_WL = "1";
      systemPackages = [
        pkgs.playerctl
      ];
    };

    programs.hyprland = {
      enable = true;
      package = inputs'.hyprland.packages.default;
      withUWSM = false;
    };
  };
}
