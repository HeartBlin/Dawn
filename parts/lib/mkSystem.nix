{ inputs, self, withSystem, ... }:

let
  inherit (inputs.nixpkgs.lib) nixosSystem;

  mkSystem = { hostName, system, userName, prettyName }:
    withSystem system ({inputs', self', ... }: let
      dawn = import "${self}/parts/data/args.nix" 
        {inherit hostName userName prettyName; };

      specialArgs = { inherit inputs inputs' self' system dawn; };

      defaultModules =  with inputs; [
        hjem.nixosModules.default
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
        };
       
        hjem.users.${userName}.enable = true;
      }];
    in {
      ${hostName} = nixosSystem {
        inherit specialArgs;
        modules = [
          "${self}/hosts/${hostName}/config.nix"
          "${self}/hosts/${hostName}/disko.nix"
          "${self}/hosts/${hostName}/hardware.nix"
        ] ++ defaultModules ++ defaultOptions;
      };
    });
in mkSystem
