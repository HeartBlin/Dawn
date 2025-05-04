{ config, inputs, pkgs, ... }:

{
  dawn = {
    hyprland = {
      enable = true;
      monitors = [{
        name = "eDP-1";
        resolution = "1920x1080";
        refreshRate = 144;
        position = { x = 0; y = 0; };
        scale = 1.0;
      }];

      wallpapers = [{
        monitor = "eDP-1";
        wallpaper = ./images/wallpaper.jpg;
      }];
    };
    
    asus.enable = true;
    fish.enable = true;
    foot.enable = true;
    minecraft.enable = true;
    steam.enable = true;
    vscode.enable = true;
  };

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Boot
  boot.initrd.kernelModules = [ "zfs" ];

  # Networking && Hostname
  networking = {
    networkmanager.enable = true;
    hostId = "73f96d11";
  };

  # Set timezone and locale
  time.timeZone = "Europe/Bucharest";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "ro_RO.UTF-8";
      LC_IDENTIFICATION = "ro_RO.UTF-8";
      LC_MEASUREMENT = "ro_RO.UTF-8";
      LC_MONETARY = "ro_RO.UTF-8";
      LC_NAME = "ro_RO.UTF-8";
      LC_NUMERIC = "ro_RO.UTF-8";
      LC_PAPER = "ro_RO.UTF-8";
      LC_TELEPHONE = "ro_RO.UTF-8";
      LC_TIME = "ro_RO.UTF-8";
    };
  };

  # Gnome
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  # PipeWire
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Nvidia GPU
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
    powerManagement.enable = true;
    open = true;
    nvidiaSettings = false;
  };

  # GNOME Boxes / Virtualization
  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true; 

  # NTFS Mounting
  boot.supportedFilesystems = [ "ntfs" ];
  services.udisks2.enable = true;

  # General Packages
  environment.systemPackages = [
    pkgs.wget
    pkgs.curl
    pkgs.git
    pkgs.neovim

    # GNOME Utilities
    pkgs.gnome-boxes
    pkgs.gnome-tweaks
    pkgs.gnome-disk-utility
    pkgs.nautilus   
    pkgs.gnome.gvfs
    pkgs.ntfs3g

    # Browser
    inputs.zen-browser.packages.${pkgs.system}.default
  ];
}
