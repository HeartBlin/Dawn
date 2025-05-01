monitors: let
  mkString = monitor: let
    resolution = "${monitor.resolution}@${toString monitor.refreshRate}";
    position = "${toString monitor.position.x}x${toString monitor.position.y}";
    scale = toString monitor.scale;
  in "monitor = ${monitor.name},${resolution},${position},${scale}";
in builtins.concatStringsSep "\n" (map mkString monitors)