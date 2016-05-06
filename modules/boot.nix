{ config, pkgs, lib, ... } : with lib;
{
  boot.loader.gummiboot.enable = true;
  boot.initrd.luks.devices = [
    {
      name = "root"; device = "/dev/nvme0n1p5"; preLVM = true;
    }
  ];
}
