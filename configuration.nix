# yawnt's laptop

{ config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
  };

  networking.hostName = "nixos"; # Define your hostname.
  
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "Europe/Rome";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    wget
    emacs
    sudo
    zsh
  ];
  programs.zsh.enable = true;
  
  users.extraUsers.yawnt = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    useDefaultShell = true;
  };


  system.autoUpgrade = {
    enable = true;
    channel = https://nixos.org/channels/nixos-unstable;
  };

  services.xserver = {
    enable = true;
    desktopManager.gnome3.enable = true;
    displayManager.gdm.enable = true;
    xkbOptions = "eurosign:e";
  };

  boot.initrd.luks.devices = [
    { 
      name = "root"; device = "/dev/sda2"; preLVM = true;
    }
  ];
}

