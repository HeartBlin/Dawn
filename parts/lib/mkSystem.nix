{ inputs, self, withSystem, ... }:

let
  inherit (inputs.nixpkgs.lib) nixosSystem;

  mkSystem = { hostName, system, userName, prettyName }:
    withSystem system ({inputs', self', ... }: let
      dawn = { inherit hostName system userName prettyName; };
      specialArgs = { inherit inputs inputs' self' system dawn; };
 
      defaultPaths = [
        "${self}/modules/packages"
      ];

      defaultModules =  with inputs; [
        homix.nixosModules.default
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
          extraGroups = [ "wheel" "video" "networkmanager" ];
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
