{ lib }:

let 
  inherit (builtins) concatStringsSep elemAt match stringLength substring;
  inherit (lib) unique;

  formatString = scale: let
    str = toString scale;
    parts = match "([0-9]+)\\.([0-9]+)" str;
    integerPart = if parts == null then str else elemAt parts 0;
    fractionalPart = if parts == null then "" else elemAt parts 1;
    trimTrailingZeros = s: let
      len = stringLength s;
      go = i: if (i < 0) then "" else let
        c = substring i 1 s;
      in if c == "0" then go (i - 1) else substring 0 (i + 1) s;
      trimmed = go (len - 1);
    in trimmed;

    trimmedFractional = trimTrailingZeros fractionalPart;
  in if trimmedFractional == "" then integerPart else "${integerPart}.${trimmedFractional}";
in {
  mkHyprWallpapers = wallpapers: let
    uniqueWallpapers = unique (map (wp: wp.wallpaper) wallpapers);
    preload = map (wpPath: "preload = ${toString wpPath}") uniqueWallpapers;
    assign = map (wp: "wallpaper = ${wp.monitor}, ${toString wp.wallpaper}") wallpapers;
  in concatStringsSep "\n" (preload ++ assign);

  mkHyprMonitors = monitors: concatStringsSep "\n" (map (m: let
    res = "${m.resolution}@${toString m.refreshRate}";
    pos = "${toString m.position.x}x${toString m.position.y}";
    scale = formatString m.scale;
  in "monitor = ${m.name}, ${res}, ${pos}, ${scale}") monitors);
}