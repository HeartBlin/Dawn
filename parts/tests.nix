{ inputs, self, ... }:

let
  inherit (inputs.nixpkgs) lib;

in {
  imports = [ inputs.nix-unit.modules.flake.default ];

  perSystem = { pkgs, ... }: let
    asusTest = import "${self}/tests/testLedChangeScript.nix" { inherit lib pkgs; };
    importAllTest = import "${self}/tests/testImportAll.nix" { inherit lib pkgs; };
    monitorTest = import "${self}/tests/testHyprMonitors.nix" { inherit lib; };
    wallpaperTest = import "${self}/tests/testHyprWallpapers.nix" { inherit lib; };
  in {
    nix-unit = {
      inputs = { inherit (inputs) nixpkgs flake-parts nix-unit systems; };
      tests = {
        "test mkHyprMonitors expression output" = {
          expr = "${monitorTest.expr}";
          expected = "${monitorTest.expected}";
        };

        "test mkHyprWallpapers expression output" = {
          expr = "${wallpaperTest.expr}";
          expected = "${wallpaperTest.expected}";
        };

        "test mkLedChangeScript expression output" = {
          expr = "${asusTest.expr}";
          expected = "${asusTest.expected}";
        };

        "test importAll function" = {
          expr = "${importAllTest.expr}";
          expected = "${importAllTest.expected}";
        };
      };
    };
  };
}
