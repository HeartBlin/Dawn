wallpapers: let
  inherit (builtins) concatStringsSep;
  string = concatStringsSep "\n" (map
    (wp: "preload = ${toString wp.wallpaper}\nwallpaper = ${wp.monitor}, ${toString wp.wallpaper}" + "\n")
    wallpapers
  );
in string