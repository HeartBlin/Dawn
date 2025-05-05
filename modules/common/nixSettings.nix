{ dawn, inputs, inputs', lib, pkgs, ... }:

let 
  inherit (lib) mapAttrs mapAttrsToList;
in {
  nixpkgs.config.allowUnfree = true;
  environment.defaultPackages = lib.mkForce [ ];

  nix = {
    package = pkgs.lix;
    registry = mapAttrs (_: flake: { inherit flake;}) inputs;
    nixPath = mapAttrsToList (x: _: "${x}=flake:${x}") inputs;
    channel.enable = false;

    settings = {
      warn-dirty = false;
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];

      allowed-users = [ "root" "@wheel" ];
      trusted-users = [ "root" "@wheel" ];

      flake-registry = "";

      sandbox = true;
      pure-eval = true;

      substituters = [ "https://cache.nixos.org/" ];
      trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
    };
  };

  programs.nh = {
    enable = true;
    package = inputs'.nh.packages.default;
    clean.enable = true;
    clean.extraArgs = "--keep 5 --keep-since 3d";
    flake = dawn.flakePath;
  };

  documentation = {
    doc.enable = false;
    info.enable = false;
    nixos.enable = false;
    man.enable = false;
  };
}