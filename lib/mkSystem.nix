{ inputs, self, withSystem, ... }:

let
  inherit (inputs.nixpkgs) lib;
  inherit (lib) nixosSystem;

  mkSystem = { hostName, system, userName, prettyName, flakePath }:
    withSystem system ({inputs', self', ... }: let      
      hyprUtils = import "${self}/lib/hyprUtils.nix" { inherit lib; };  

      dawn = { inherit hostName system userName prettyName flakePath hyprUtils; };
      specialArgs = { inherit inputs inputs' self' self system dawn; };
 
      defaultPaths = [
        "${self}/modules/common/fonts.nix"
        "${self}/modules/common/nixSettings.nix"
        "${self}/modules/packages"
      ];

      defaultModules =  with inputs; [
        homix.nixosModules.default
        hyprland.nixosModules.default
        disko.nixosModules.default
        lixModule.nixosModules.default
      ];

      defaultOptions = [{
        networking.hostName = hostName;
        nixpkgs.hostPlatform = system;
        system.stateVersion = "25.05";
        users.users.${userName} = {
          description = prettyName;
          isNormalUser = true;
          extraGroups = [ "wheel" "video" "networkmanager" "fuse" ];
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
        ] ++ defaultPaths ++ defaultModules ++ defaultOptions;
      };
    });
in mkSystem
