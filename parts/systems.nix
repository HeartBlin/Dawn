{ inputs, self, withSystem, ... }:

let
  inherit (inputs.nixpkgs.lib) mkMerge;

  mkSystem = import ./lib/mkSystem.nix { inherit inputs self withSystem;};
in {
  flake.nixosConfigurations = mkMerge [
    # Vega, a ROG Strix G513IE
    (mkSystem {
      hostName = "Vega";
      system = "x86_64-linux";
      userName = "heartblin";
      prettyName = "HeartBlin";
    })
  ];
}