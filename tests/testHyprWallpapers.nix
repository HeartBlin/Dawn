{
  expected = ''preload = /home/user/wall.jpg
wallpaper = eDP-1, /home/user/wall.jpg

preload = /home/user/wall.png
wallpaper = HDMI-A-1, /home/user/wall.png
'';

  expr = let
    mkHyprWallpapers = import ../parts/lib/mkHyprWallpapers.nix;
    sample = [
      { monitor = "eDP-1"; wallpaper = "/home/user/wall.jpg"; }
      { monitor = "HDMI-A-1"; wallpaper = "/home/user/wall.png"; }
    ];
  in mkHyprWallpapers sample;
}