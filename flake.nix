{
  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ ./parts ];
      systems = import inputs.systems;
    };

  inputs = {
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

    homix.url = "github:sioodmy/homix";
    homix.inputs.nixpkgs.follows = "nixpkgs";

    hyprland.url = "github:hyprwm/hyprland";

    hyprpaper.url = "github:hyprwm/hyprpaper";
    hyprpaper.inputs.hyprgraphics.follows = "hyprland/hyprgraphics";
    hyprpaper.inputs.hyprlang.follows = "hyprland/hyprlang";
    hyprpaper.inputs.hyprutils.follows = "hyprland/hyprutils";
    hyprpaper.inputs.nixpkgs.follows = "hyprland/nixpkgs";
    hyprpaper.inputs.systems.follows = "hyprland/systems";

    prismlauncher.url = "github:PrismLauncher/PrismLauncher";
    prismlauncher.inputs.nixpkgs.follows = "nixpkgs";

    nh.url = "github:viperML/nh";
    nh.inputs.nixpkgs.follows = "nixpkgs";

    nix-minecraft.url = "github:Infinidoge/nix-minecraft";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-unit.url = "github:nix-community/nix-unit";
    nix-unit.inputs.nixpkgs.follows  = "nixpkgs";
    nix-unit.inputs.flake-parts.follows = "flake-parts";

    systems.url = "github:nix-systems/default-linux";

    zen-browser.url = "github:youwen5/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";
  };
}
