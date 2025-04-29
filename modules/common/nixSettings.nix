{ dawn, inputs', ... }:

{
  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    warn-dirty = false;
    auto-optimise-store = true;
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" "@wheel" ];
  };

  programs.nh = {
    enable = true;
    package = inputs'.nh.packages.default;
    clean.enable = true;
    clean.extraArgs = "--keep 5 --keep-since 3d";
    flake = dawn.defaultFlakeLocation;
  };
}