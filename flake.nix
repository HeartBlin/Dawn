{
  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ ./parts ];
      systems = import inputs.systems;
    };

  inputs = {
    disko.url =       "github:nix-community/disko";
    flake-parts.url = "github:hercules-ci/flake-parts";
    homix.url =       "github:sioodmy/homix";
    lixModule.url =   "https://git.lix.systems/lix-project/nixos-module/archive/2.92.0-3.tar.gz";
    nh.url =          "github:viperML/nh";
    nixpkgs.url =     "github:NixOS/nixpkgs/nixos-unstable";
    systems.url =     "github:nix-systems/x86_64-linux";
    zen-browser.url = "github:youwen5/zen-browser-flake";
  };
}
