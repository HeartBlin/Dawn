let
  diskId = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_Plus_1TB_S4EWNX1W519812T";
  swapSize = "24G";
  espSize = "1G";
in {
  disko.devices = {
    disk.root = {
      type = "disk";
      device = diskId;
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            type = "EF00";
            size = espSize;
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "nofail" ];
            };
          };

          swap = {
            size = swapSize;
            content.type = "swap";
          };

          zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "origin";
            };
          };
        };
      };
    };

    zpool = {
      origin = {
        type = "zpool";
        rootFsOptions = {
          mountpoint = "none";
          compression = "zstd";
          acltype = "posixacl";
          xattr = "sa";
          "com.sun:auto-snapshot" = "true";
        };

        options.ashift = "12";
        datasets = {
          "root" = {
            type = "zfs_fs";
            mountpoint = "/";
            options = {
              encryption = "aes-256-gcm";
              keyformat = "passphrase";
              keylocation = "prompt";
            };
          };

          "root/nix" = {
            type = "zfs_fs";
            options.mountpoint = "/nix";
            mountpoint = "/nix";
          };
        };
      };
    };
  };
}
