{ lib }:

{
  expected = ''preload = /home/user/wall.jpg
preload = /home/user/wall.png
wallpaper = eDP-1, /home/user/wall.jpg
wallpaper = HDMI-A-1, /home/user/wall.png
wallpaper = DP-1, /home/user/wall.jpg'';

  expr = let
    mkHyprWallpapers = import ../lib/hyprUtils.nix { inherit lib; }.mkHyprWallpapers;
    sample = [
      { monitor = "eDP-1"; wallpaper = "/home/user/wall.jpg"; }
      { monitor = "HDMI-A-1"; wallpaper = "/home/user/wall.png"; }
      { monitor = "DP-1"; wallpaper = "/home/user/wall.jpg"; }
    ];
  in mkHyprWallpapers sample;
}
