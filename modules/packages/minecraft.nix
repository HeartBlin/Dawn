{ config, inputs', lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.dawn) minecraft;
in {
  options.dawn.minecraft.enable = mkEnableOption "Enables Minecraft Launcher";
  
  config = mkIf minecraft.enable {
    nix.settings = {
      substituters = [ "https://prismlauncher.cachix.org" ];
      trusted-public-keys = [ "prismlauncher.cachix.org-1:9/n/FGyABA2jLUVfY+DEp4hKds/rwO+SCOtbOkDzd+c=" ];
    };

    environment.systemPackages = [
      inputs'.prismlauncher.packages.prismlauncher
    ];
  };
}
