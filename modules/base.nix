{ config, lib, pkgs, ...}: with lib;
let zoppoDir = ../dotfiles/zoppo;
in
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
  programs.zsh.shellInit = ''
    source ${zoppoDir}/templates/zshenv
  '';
  programs.zsh.interactiveShellInit = ''
    # Heiwa Theme
    zstyle ':zoppo:prompt:borra' plugins 'userhost' 'vcs-info'
    zstyle ':zoppo:prompt:borra' prefix '%F{red}(%f'
    zstyle ':zoppo:prompt:borra' suffix '%F{red})%f'
    zstyle ':zoppo:prompt:borra' separator '%F{red} %f'
    zstyle ':zoppo:prompt:borra' top '%F{red}┌%f'
    zstyle ':zoppo:prompt:borra' bottom '%F{red}╰─%f'
    zstyle ':zoppo:prompt:borra' prompt '%F{red}(%f%B%$((COLUMNS / 2))<...<%~%<<%b%F{red})%F{red}>%f '
    zstyle ':zoppo:prompt:borra' rprompt '%(?..%F{red}%? ↵%f)'
    zstyle ':zoppo:prompt:borra:plugin:userhost' format '%U%F{red}@%f%h'
    zstyle ':zoppo:prompt:borra:plugin:vcs' format '%b%F{red}|%f%i'

    source ${zoppoDir}/templates/zopporc
  '';
  programs.zsh.promptInit = ''
    [ -s "${zoppoDir}/zoppo.zsh" ] && source "${zoppoDir}/zoppo.zsh"
  '';

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

    # Irssi
    ln -fsn ${../dotfiles/irssi} $USER_HOME/.irssi

    # Tmux
    ln -fs ${../dotfiles/tmux.conf} $USER_HOME/.tmux.conf

    # Sbt
    rm -rf $USER_HOME/.sbt/0.13/plugins
    mkdir -p $USER_HOME/.sbt/0.13/plugins
    ln -fs ${../dotfiles/sbt/0.13/plugins/plugins.sbt} $USER_HOME/.sbt/0.13/plugins/plugins.sbt

    # Konsole
    rm -rf $USER_HOME/.local/share/konsole
    mkdir -p $USER_HOME/.local/share/
    ln -fs ${../dotfiles/local/share/konsole} $USER_HOME/.local/share/konsole
  '';
}
