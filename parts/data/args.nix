{ hostName, userName, prettyName }:

let
  dawn = {
    inherit hostName;
    inherit userName;
    inherit prettyName;
  };
in dawn