{
  expected = ''
monitor = eDP-1, 1920x1080@144, 0x0, 1.0
monitor = HDMI-A-1, 1920x1080@60, 1920x0, 1.0
monitor = DP-1, 1280x720@75, 100x50, 1.2
monitor = HDMI-B-2, 2560x1440@144, 0x1080, 0.7
monitor = VGA-1, 1024x768@60, 320x240, 2.0'';

  expr = let
    mkHyprMonitors = import ../../parts/lib/mkHyprMonitors.nix;
    sample = [
      { name = "eDP-1"; resolution = "1920x1080"; refreshRate = 144; position = { x = 0; y = 0; }; scale = 1.0; }
      { name = "HDMI-A-1"; resolution = "1920x1080"; refreshRate = 60; position = { x = 1920; y = 0; }; scale = 1.0; }
      { name = "DP-1"; resolution = "1280x720"; refreshRate = 75; position = { x = 100; y = 50; }; scale = 1.23; }
      { name = "HDMI-B-2"; resolution = "2560x1440"; refreshRate = 144; position = { x = 0; y = 1080;}; scale = 0.75; }
      { name = "VGA-1"; resolution = "1024x768"; refreshRate = 60; position = { x = 320; y = 240; }; scale = 2.0; }
    ];
  in mkHyprMonitors sample;
}