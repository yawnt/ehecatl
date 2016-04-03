# yawnt's laptop

{ config, lib, pkgs, ... }:

with lib;
let hostName = "${builtins.readFile ./hostname}";
in
rec {
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
  };

  networking.hostName = "${hostName}";

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "Europe/Rome";

  environment.systemPackages = with pkgs; [
    wget
    emacs
    sudo
    zsh
    tmux
    irssi
    kde5.konsole
    fira-code
  ];

  programs.zsh.enable = true;

  users.extraUsers.yawnt = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    useDefaultShell = true;
    initialPassword = "password";
    #home = /home/yawnt;
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

  system.activationScripts.dotfiles = stringAfter [ "users" ]
    ''
    export USER_HOME=/home/yawnt

    # Emacs
    ln -fsn ${./dotfiles/emacs.d} $USER_HOME/.emacs.d

    # Zoppo + ZSH
    ln -fsn ${./dotfiles/zoppo} $USER_HOME/.zoppo
    ln -fs ${./dotfiles/zshrc} $USER_HOME/.zshrc
    ln -fs ${./dotfiles/zopporc} $USER_HOME/.zopporc
    ln -fs ${./dotfiles/zshenv} $USER_HOME/.zshenv

    # Irssi
    ln -fsn ${./dotfiles/irssi} $USER_HOME/.irssi

    # Tmux
    ln -fs ${./dotfiles/tmux.conf} $USER_HOME/.tmux.conf

    # Konsole
    mkdir -p $USER_HOME/.local/share/
    ln -fs ${./dotfiles/local/share/konsole} $USER_HOME/.local/share/
    '';
}

