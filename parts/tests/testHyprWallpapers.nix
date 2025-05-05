{
  expected = ''preload = /home/heartblin/wall.jpg
wallpaper = eDP-1, /home/heartblin/wall.jpg

preload = /home/heartblin/wall.png
wallpaper = HDMI-A-1, /home/heartblin/wall.png
'';

  expr = let
    mkHyprWallpapers = import ../../parts/lib/mkHyprWallpapers.nix;
    sample = [
      { monitor = "eDP-1"; wallpaper = "/home/heartblin/wall.jpg"; }
      { monitor = "HDMI-A-1"; wallpaper = "/home/heartblin/wall.png"; }
    ];
  in mkHyprWallpapers sample;
}