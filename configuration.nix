# yawnt's laptop

{ config, pkgs, ... }:

let hostName = "${builtins.readFile ./hostname}";
    home = /home/yawnt;
in
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
  ];

  programs.zsh.enable = true;

  users.extraUsers.yawnt = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    useDefaultShell = true;
    initialPassword = "password";
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
    # Emacs
    ln -fs ${./dotfiles/.emacs.d} ${home}/.emacs.d

    # Zoppo
    ln -fs ${./dotfiles/.zoppo} ${home}/.zoppo
    ln -fs ${./dotfiles/.zopporc} ${home}/.zopporc
    ln -fs ${./dotfiles/.zshenv} ${home}/.zshenv

    # Irssi
    ln -fs ${./dotfiles/.irssi} ${home}/.irssi

    # Tmux
    ln -fs ${./dotfiles/.tmux.conf} ${home}/.tmux.conf

    # Konsole
    mkdir -p ${home}/.local/share/
    ln -fs ${./dotfiles/.local/share/konsole} ${home}/.local/share/konsole
    '';
}
