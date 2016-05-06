{ config, lib, pkgs, ... }:

with lib;
let hostName = "${builtins.readFile ./hostname}";
    dockerCfg = "${builtins.readFile ./docker}";
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
      oraclejdk8 = pkgs.callPackage (import ./jdk.nix {
        productVersion = "8";
        patchVersion = "91";
        downloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html;
        sha256_i686 = "0lndni81vfpz2l6zb8zsshaavk0483q5jc8yzj4fdjv6wnshbkay";
        sha256_x86_64 = "0lkm3fz1vdi69f34sysavvh3abx603j1frc9hxvr08pwvmm536vg";
        jceName = "jce_policy-8.zip";
        jceDownloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html;
        sha256JCE = "0n8b6b8qmwb14lllk2lk1q1ahd3za9fnjigz5xn65mpg48whl0pk";
      }) {};
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
    oraclejdk8
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
    gnome.libgnomecups
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
    libreoffice
    maven
    poppler_utils
    poppler
    protobuf3_0
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

  systemd.user.services.emacs = {
    description = "Emacs Daemon";
    environment = {
      GTK_DATA_PREFIX = config.system.path;
      SSH_AUTH_SOCK = "%t/ssh-agent";
      GTK_PATH = "${config.system.path}/lib/gtk-3.0:${config.system.path}/lib/gtk-2.0";
      NIX_PROFILES = "${pkgs.lib.concatStringsSep " " config.environment.profiles}";
      TERMINFO_DIRS = "/run/current-system/sw/share/terminfo";
      ASPELL_CONF = "dict-dir /run/current-system/sw/lib/aspell";
    };
    serviceConfig = {
      Type = "forking";
      ExecStart = "${pkgs.emacs}/bin/emacs --daemon";
      ExecStop = "${pkgs.emacs}/bin/emacsclient --eval (kill-emacs)";
      Restart = "always";
    };
    wantedBy = [ "default.target" ];
  };

  systemd.services.emacs.enable = true;

  services = {
    printing = {
      enable = true;
      drivers = [ pkgs.gutenprint ];
    };
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
    postgresql = {
      enable = true;
      package = pkgs.postgresql94;
      authentication = "local all all ident";
    };
    redshift = {
      enable = true;
      latitude = "41.8919300"; # Rome
      longitude = "12.5113300";
    };
  };

  virtualisation.docker = {
    enable = true;
    extraOptions = dockerCfg;
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

    # Sbt
    rm -rf $USER_HOME/.sbt/0.13/plugins
    mkdir -p $USER_HOME/.sbt/0.13/plugins
    ln -fs ${./dotfiles/sbt/0.13/plugins/plugins.sbt} $USER_HOME/.sbt/0.13/plugins/plugins.sbt
    echo 'export JAVA_HOME="${pkgs.oraclejdk8}"' > $USER_HOME/.zprofile

    # Konsole
    rm -rf $USER_HOME/.local/share/konsole
    mkdir -p $USER_HOME/.local/share/
    ln -fs ${./dotfiles/local/share/konsole} $USER_HOME/.local/share/konsole
    '';
}
