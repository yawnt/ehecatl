{ config, pkgs, lib, ... } : with lib;
{
  boot.loader.systemd-boot.enable = true;
  boot.initrd.luks.devices = [
    {
      name = "root"; device = "/dev/nvme0n1p5"; preLVM = true;
    }
  ];
}
