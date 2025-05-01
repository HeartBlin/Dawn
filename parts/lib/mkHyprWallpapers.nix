wallpapers: let
  inherit (builtins) attrNames concatStringsSep listToAttrs;

  uniqueWallpaper = attrNames (listToAttrs (map
    (wp: {
      name = toString wp.wallpaper;
      value = null;
    }) wallpapers
  ));

  preloadString = map (path: "preload = ${path}") uniqueWallpaper;
  wallpaperString = map (wp: "wallpaper = ${wp.monitor}, ${toString wp.wallpaper}") wallpapers;

  all = concatStringsSep "\n" (preloadString ++ wallpaperString);
in "${all}"