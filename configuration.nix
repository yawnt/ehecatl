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

  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs : {
      sbt = pkgs.sbt.override { jre = pkgs.oraclejre8; };
      leiningen = pkgs.leiningen.override { jdk = pkgs.oraclejdk8; };
    };
  };

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
    curl
    emacs
    sudo
    zsh
    tmux
    irssi
    fira-code
    kde5.konsole
    opam
    merlin
    ocp-indent
    oasis
    sbt
    leiningen
  ];

  programs.zsh.enable = true;

  users.extraUsers.yawnt = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    useDefaultShell = true;
    initialPassword = "password";
    home = "/home/yawnt";
    shell = "/run/current-system/sw/bin/zsh";
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
    export USER_HOME=${users.extraUsers.yawnt.home}

    # Emacs
    rm -rf $USER_HOME/.emacs.d
    cp -r ${./dotfiles/emacs.d} $USER_HOME/.emacs.d
    chown -R yawnt:users $USER_HOME/.emacs.d
    chmod -R 755 $USER_HOME/.emacs.d
    # Prelude required a writable directory, we can't use
    # ln -fsn ${./dotfiles/emacs.d} $USER_HOME/.emacs.d

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
