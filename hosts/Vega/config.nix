{ config, inputs, pkgs, ... }:

let
  inherit (config.dawn.hyprland) monitors;
  wallpaper = pkgs.fetchurl {
    url = "https://i.imgur.com/CzGdSG6.jpeg";
    sha256 = "sha256-spyiaJ5LFppEnmdWej59j8AQ3Y+WdXkJUfQqkDp7JDk=";
  };
in {
  dawn = {
    asus = {
      enable = true;
      ledColors = [ "0066FF" "00A69D" "00E63B" "00FF14" ];
    };
    
    hyprland = {
      enable = true;
      monitors = [
        {
          name = "eDP-1";
          resolution = "1920x1080";
          refreshRate = 144;
          position = { x = 0; y = 0; };
          scale = 1.0;
        }
        {
          name = "HDMI-A-1";
          resolution = "1920x1080";
          refreshRate = 60;
          position =  { x = 1920; y = 0; };
          scale = 1.0;
        }
      ];

      wallpapers = map (m: {
        inherit wallpaper;
        monitor = m.name;
      }) monitors;
    };

    minecraft = {
      enable = true;
      server.enable = true;
    };

    fish.enable = true;
    foot.enable = true;
    ly.enable = true;
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

  # X11
  services.xserver.enable = true;

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
