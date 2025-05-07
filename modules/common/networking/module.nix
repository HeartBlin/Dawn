{ lib, ... }:

let
  inherit (lib) mkForce;
in {
  systemd = {
    network = {
      enable = true;

      networks."40-wired" = {
        matchConfig.Name = "en*";
        networkConfig = {
          DHCP = "yes";
          IPv6AcceptRA = true;
          LinkLocalAddressing = "ipv6";
        };

        dhcpConfig.RouteMetric = 100;
      };
    };

    services = {
      systemd-udev-settle.enable = mkForce false;
      NetworkManager-wait-online.enable = mkForce false;
    };
  };

  services.resolved.enable = true;

  networking = {
    networkmanager.enable = mkForce false;
    dhcpcd.enable = mkForce false;
    useNetworkd = true;
    useDHCP = false;

    wireless.iwd = {
      enable = mkForce true;
      settings = {
        IPv6.Enabled = true;
        Settings = {
          AutoConnect = true;
          FrequencyPreference = "5ghz";
        };

        General = {
          EnableNetworkConfiguration = true;
          AddressRandomization = "once";
        };

        Network = {
          EnableIPv6 = true;
          RoutePriorityOffset = 300;
        };
      };
    };
  };
}
