{ config, inputs', lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.dawn) minecraft;
in {
  options.dawn.minecraft = {
    enable = mkEnableOption "Enables Minecraft Launcher";
    server.enable = mkEnableOption "Enables a Minecraft Server";
  };

  config = mkIf minecraft.enable {
    nix.settings = {
      substituters = [ "https://prismlauncher.cachix.org" ];
      trusted-public-keys = [ "prismlauncher.cachix.org-1:9/n/FGyABA2jLUVfY+DEp4hKds/rwO+SCOtbOkDzd+c=" ];
    };

    environment.systemPackages = [
      inputs'.prismlauncher.packages.prismlauncher
    ];

    services.minecraft-servers = mkIf minecraft.server.enable {
      enable = true;
      eula = true;
      openFirewall = true;
      servers."Dawn" = {
        enable = true;
        autoStart = false;
        package = pkgs.fabricServers.fabric-1_21_4.override {
          loaderVersion = "0.16.14";
        };

        serverProperties = {
          gamemode = "survival";
          difficulty = "normal";
          simulation-distance = 10;
          level-seed = "4013044327186489796";
        };

        symlinks.mods = pkgs.linkFarmFromDrvs "mods" (builtins.attrValues {
          Carpet = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/TQTTVgYE/versions/aVB2lYQQ/fabric-carpet-1.21.4-1.4.161%2Bv241203.jar";
            sha512 = "sha512-/UL0Ouia91U+4bgkDv2heKBfWw9F/jWWUc6kaM/RH+JJlumRwzhSL0oXsHuRfp69pKXPqFUfyigMgeU2skCpbA==";
          };
        });
      };
    };
  };
}
