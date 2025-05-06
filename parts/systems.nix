{ inputs, self, withSystem, ... }:

let
  inherit (inputs.nixpkgs.lib) mkMerge;

  mkSystem = import "${self}/lib/mkSystem.nix" { inherit inputs self withSystem;};
in {
  flake.nixosConfigurations = mkMerge [
    # Vega, a ROG Strix G513IE
    (mkSystem rec {
      hostName = "Vega";
      system = "x86_64-linux";
      userName = "heartblin";
      prettyName = "HeartBlin";
      flakePath = "/home/${userName}/Documents/Dawn";
    })
  ];
}
