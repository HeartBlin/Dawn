{ config, inputs, pkgs, ... }:

let
  inherit (config.dawn.hyprland) monitors;
  wallpaper = pkgs.fetchurl {
    url = "https://i.imgur.com/CzGdSG6.jpeg";
    sha256 = "sha256-spyiaJ5LFppEnmdWej59j8AQ3Y+WdXkJUfQqkDp7JDk=";
  };

  offset = x: { inherit x; y = 0; };
  defaultMonitor = {
    resolution = "1920x1080";
    scale = 1.0;
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
        (defaultMonitor // {
          name = "eDP-1";
          refreshRate = 144;
          position = offset 0;
        })
        (defaultMonitor // {
          name = "HDMI-A-1";
          refreshRate = 60;
          position = offset 1920;
        })
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
