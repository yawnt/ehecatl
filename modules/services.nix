{ config, lib, pkgs, ...}: with lib;
let dockerCfg = "${builtins.readFile ../docker}";
in
{
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
    extraOptions = "${dockerCfg}";
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

}
