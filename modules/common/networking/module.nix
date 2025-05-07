{ lib, ... }:

let
  inherit (lib) mkForce;
in {
  networking = {
    networkmanager.enable = mkForce false;
    wireless.iwd = {
      enable = mkForce true;
      settings = {
        IPv6.Enabled = true;
        Settings.AutoConnect = true;
      };
    };
  };
}
