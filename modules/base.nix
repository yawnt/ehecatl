{ config, lib, pkgs, ...}: with lib;
let zoppo = pkgs.fetchgit {
  url = "https://github.com/zoppo/zoppo.git";
  rev = "2f543ae5dc499abc8735a9c05f8b6ccba52223b3";
  sha256 = "0jaxz81f2pn7f8b71lw28r6n2pkbnl45i4mzd2g7i08d9kyclvll";
  fetchSubmodules = true;
};
in
rec {
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "Europe/Rome";

  environment.shellAliases = {
    pdfcompress = "gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook -sOutputFile=$2 $1";
    whiteboard = "convert $1 -morphology Convolve DoG:15,100,0 -negate -normalize -blur 0x1 -channel RBG -level 60%,91%,0.1 $2";
  };

  environment.profileRelativeEnvVars = {
    JAVA_HOME = ["${pkgs.jdk}"];
  };

  nixpkgs.config.chromium.enableWideVine = true;

  networking.extraHosts = ''
    127.0.0.1 dockerhost
  '';

  environment.systemPackages = with pkgs; [
    # Network
    wget
    curl
    chromium
    irssi
    thunderbird

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
    ghostscript
    pdftk
    libtiff

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
    source ${zoppo}/templates/zshenv
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

    source ${zoppo}/templates/zopporc
  '';
  programs.zsh.promptInit = ''
    [ -s "${zoppo}/zoppo.zsh" ] && source "${zoppo}/zoppo.zsh"
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
