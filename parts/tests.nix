{ inputs, self, ... }:

let
  monitorExpr = (import "${self}/tests/testHyprMonitors.nix").expr;
  monitorExpect = (import "${self}/tests/testHyprMonitors.nix").expected;
  wallpaperExpr = (import "${self}/tests/testHyprWallpapers.nix").expr;
  wallpaperExpect = (import "${self}/tests/testHyprWallpapers.nix").expected;
in {
  imports = [ inputs.nix-unit.modules.flake.default ];

  perSystem = { ... }: {
    nix-unit = {
      inputs = { inherit (inputs) nixpkgs flake-parts nix-unit systems; };
      tests = {
        "test mkHyprMonitors expression output" = {
          expr = "${monitorExpect}";
          expected = "${monitorExpr}";
        };

        "test mkHyprWallpapers expression output" = {
          expr = "${wallpaperExpr}";
          expected = "${wallpaperExpect}";
        };
      };
    };
  };
}