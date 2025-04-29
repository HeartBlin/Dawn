{ config, dawn, inputs, lib, pkgs, ... }:

{
  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow non-free packages
  nixpkgs.config.allowUnfree = true;

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Boot
  boot.initrd.kernelModules = [ "zfs" "nvidia_modeset" "nvidia" "nvidia_uvm" "nvidia_drm" ];
  boot.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];

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

  # User definition
  programs.fish.enable = true;
  users.users.${dawn.userName}.shell = pkgs.fish;

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

  # Fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf
    corefonts
    font-awesome
  ];

  # Automatic Maintenance
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  system.autoUpgrade = {
    enable = true;
    flake = "/home/priestess/Ark";
    dates = "daily";
    allowReboot = false;
  };
}