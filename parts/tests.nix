{ inputs, self, ... }:

let
  inherit (inputs.nixpkgs) lib;

  monitorExpr = (import "${self}/tests/testHyprMonitors.nix" { inherit lib; }).expr;
  monitorExpect = (import "${self}/tests/testHyprMonitors.nix" { inherit lib; }).expected;
  wallpaperExpr = (import "${self}/tests/testHyprWallpapers.nix" { inherit lib; }).expr;
  wallpaperExpect = (import "${self}/tests/testHyprWallpapers.nix" { inherit lib; }).expected;
in {
  imports = [ inputs.nix-unit.modules.flake.default ];

  perSystem = { ... }: {
    nix-unit = {
      inputs = { inherit (inputs) nixpkgs flake-parts nix-unit systems; };
      tests = {
        "test mkHyprMonitors expression output" = {
          expr = "${monitorExpr}";
          expected = "${monitorExpect}";
        };

        "test mkHyprWallpapers expression output" = {
          expr = "${wallpaperExpr}";
          expected = "${wallpaperExpect}";
        };
      };
    };
  };
}