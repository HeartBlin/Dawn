{ inputs, self, withSystem, ... }:

let
  inherit (inputs.nixpkgs) lib;
  inherit (lib) nixosSystem;

  mkSystem = { hostName, system, userName, prettyName, flakePath }:
    withSystem system ({inputs', self', pkgs, ... }: let
      hyprUtils = import "${self}/lib/hyprUtils.nix" { inherit lib; };
      asusUtils = import "${self}/lib/asusUtils.nix" { inherit lib pkgs; };
      importAll = import "${self}/lib/importAll.nix" { inherit lib; };

      dawn = { inherit hostName system userName prettyName flakePath
                       asusUtils hyprUtils importAll; };

      specialArgs = { inherit inputs inputs' self' self system dawn; };

      defaultPaths = [
        "${self}/modules/common"
        "${self}/modules/packages"
      ];

      defaultModules =  with inputs; [
        chaotic.nixosModules.default
        homix.nixosModules.default
        hyprland.nixosModules.default
        disko.nixosModules.default
        nix-minecraft.nixosModules.minecraft-servers
      ];

      defaultOverlays = with inputs; [{
        nixpkgs.overlays = [ nix-minecraft.overlay ];
      }];

      defaultOptions = [{
        networking.hostName = hostName;
        nixpkgs.hostPlatform = system;
        system.stateVersion = "25.05";
        users.users.${userName} = {
          description = prettyName;
          isNormalUser = true;
          extraGroups = [ "wheel" "video" "network" "fuse" "minecraft" ];
          homix = true;
        };
      }];
    in {
      ${hostName} = nixosSystem {
        inherit specialArgs;
        modules = [
          "${self}/hosts/${hostName}/config.nix"
          "${self}/hosts/${hostName}/disko.nix"
          "${self}/hosts/${hostName}/hardware.nix"
        ] ++ defaultPaths ++ defaultModules ++ defaultOptions ++ defaultOverlays;
      };
    });
in mkSystem
