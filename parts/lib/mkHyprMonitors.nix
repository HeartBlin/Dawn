monitors: builtins.concatStringsSep "\n"
  (map (monitor: let
    res = "${monitor.resolution}@${toString monitor.refreshRate}";
    pos = "${toString monitor.position.x}x${toString monitor.position.y}";
    scale = let
      whole = builtins.floor (monitor.scale * 10);
      intPart = builtins.floor (whole / 10);
      decPart = whole - (intPart * 10);
    in "${toString intPart}.${toString decPart}";
  in "monitor = ${monitor.name}, ${res}, ${pos}, ${scale}"
) monitors)