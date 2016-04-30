{ config, lib, pkgs, ... }:

with lib;
let hostName = "${builtins.readFile ./hostname}";
    default = ./default.el;
    tmpInit = ./tmpInit.el;
    tmpCompile = ./tmpCompile.el;
    yawntEmacs = ./yawnt.el;
    prelude = pkgs.fetchgit {
      url = https://github.com/bbatsov/prelude.git;
      rev = "2b85871805526261b6c3600a4fd103538ebee96f";
      sha256 = "1vl7v3gks78r4k9dzhhzhlkwqjaxmv13pd9zv1hz0d3k84mryc3c";
    };
in
rec {
  imports =
    [
      ./hardware-configuration.nix
    ];

  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs : rec {
      sbt = pkgs.sbt.override { jre = pkgs.oraclejre8; };
      leiningen = pkgs.leiningen.override { jdk = pkgs.oraclejdk8; };                                                                                 
      apacheKafka = pkgs.apacheKafka.override { jre = pkgs.oraclejre8; };
      emacs = pkgs.emacs.overrideDerivation (drv : {
        postInstall = drv.postInstall + ''
          cp -r ${prelude} $out/share/emacs/site-lisp/prelude
          chmod -R a+w $out/share/emacs/site-lisp/
          cp ${yawntEmacs} $out/share/emacs/site-lisp/prelude/personal/yawnt.el
          $out/bin/emacs -batch -l ${tmpInit}
          $out/bin/emacs -batch -l ${tmpCompile}
          cp ${default} $out/share/emacs/site-lisp/default.el
          chmod a+w $out/share/emacs/site-lisp/default.el
          echo "(load (expand-file-name \"init.el\" \"$out/share/emacs/site-lisp/prelude\"))" >> $out/share/emacs/site-lisp/default.el
        '';
      });
    };
  };

  #environment.etc."nix/nixpkgs-config.nix".text = "(import <nixpkgs/nixos> {}).config.nixpkgs.config";

  boot.loader.gummiboot.enable = true;

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
    git
    ocamlPackages.merlin
    ocamlPackages.ocpIndent
    ocamlPackages.ocaml_oasis
    chromium
    xsel
    sbt
    leiningen
    powertop
    meld
    gnome3.gnome-tweak-tool
    unzip
    openvpn
    mpv
    cutegram
    ncmpc
    apacheKafka
    rdkafka
    gcc
    autoconf
    automake
    inkscape
    nix-prefetch-scripts
    python27Packages.docker_compose
    networkmanagerapplet
  ];

  programs.zsh.enable = true;

  users.extraUsers.yawnt = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    useDefaultShell = true;
    initialPassword = "password";
    home = "/home/yawnt";
    shell = "/run/current-system/sw/bin/zsh";
  };


  system.autoUpgrade = {
    enable = true;
    channel = https://nixos.org/channels/nixos-unstable;
  };

  services = {
    xserver = {
      enable = true;
      desktopManager.gnome3 = {
        enable = true;
        extraGSettingsOverrides = ''
          [org.gnome.desktop.interface]
          scaling-factor=2
        '';
      };
      displayManager.gdm.enable = true;
      xkbOptions = "eurosign:e";
      synaptics = {
        enable = true;
        minSpeed = "0.8";
        maxSpeed = "0.8";
        accelFactor = "0.03";
      };
      videoDrivers = ["intel"];
    };
    mpd.enable = true;
    postgresql = {
      enable = true;
      package = pkgs.postgresql94;
      authentication = "local all all ident";
    };
  };

  virtualisation.docker = {
    enable = true;
    extraOptions = ''

    '';
  };

  boot.initrd.luks.devices = [
    {
      name = "root"; device = "/dev/nvme0n1p5"; preLVM = true;
    }
  ];

  system.activationScripts.dotfiles = stringAfter [ "users" ]
    ''
    export USER_HOME=${users.extraUsers.yawnt.home}

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
    rm -rf $USER_HOME/.local/share/konsole
    mkdir -p $USER_HOME/.local/share/
    ln -fs ${./dotfiles/local/share/konsole} $USER_HOME/.local/share/konsole
    '';
}
