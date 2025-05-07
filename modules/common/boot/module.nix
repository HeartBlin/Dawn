_: {
  services.journald.extraConfig = "SystemMaxUse=50M";
  boot = {
    kernelParams = [ "quiet" "loglevel=3" "8250.nr_uarts=0" ];
    initrd.systemd.enable = true;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 0;
    };
  };
}
