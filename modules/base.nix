{ config, lib, pkgs, ...}: with lib;
rec {
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "Europe/Rome";

  environment.systemPackages = with pkgs; [
    # Network
    wget
    curl
    chromium
    irssi

    # System
    sudo
    zsh
    tmux
    fira-code
    kde5.konsole
    xsel
    powertop
    unzip
    openvpn

    # Gnome
    gnome3.gnome-tweak-tool
    gnome.libgnomecups

    # Media
    cutegram
    mpv
    inkscape

    # Office
    libreoffice
    poppler_utils
    poppler
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

  system.activationScripts.dotfiles = stringAfter [ "users" ] ''
    export USER_HOME=${users.extraUsers.yawnt.home}

    # Zoppo + ZSH
    ln -fsn ${../dotfiles/zoppo} $USER_HOME/.zoppo
    ln -fs ${../dotfiles/zshrc} $USER_HOME/.zshrc
    ln -fs ${../dotfiles/zopporc} $USER_HOME/.zopporc
    ln -fs ${../dotfiles/zshenv} $USER_HOME/.zshenv

    # Irssi
    ln -fsn ${../dotfiles/irssi} $USER_HOME/.irssi

    # Tmux
    ln -fs ${../dotfiles/tmux.conf} $USER_HOME/.tmux.conf

    # Sbt
    rm -rf $USER_HOME/.sbt/0.13/plugins
    mkdir -p $USER_HOME/.sbt/0.13/plugins
    ln -fs ${../dotfiles/sbt/0.13/plugins/plugins.sbt} $USER_HOME/.sbt/0.13/plugins/plugins.sbt
    echo 'export JAVA_HOME="${pkgs.oraclejdk8}"' > $USER_HOME/.zprofile

    # Konsole
    rm -rf $USER_HOME/.local/share/konsole
    mkdir -p $USER_HOME/.local/share/
    ln -fs ${../dotfiles/local/share/konsole} $USER_HOME/.local/share/konsole
  '';
}
