{ ... }:

{
  boot = {
    kernelParams = [ "quiet" "loglevel=3" ];
    initrd.systemd.enable = true;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 0;
    };
  };
}