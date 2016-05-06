{ config, lib, pkgs, ... }:

with lib;
let hostName = "${builtins.readFile ./hostname}";
in
rec {
  imports =
    [
      ./hardware-configuration.nix
      ./modules/boot.nix
      ./modules/base.nix
      ./modules/services.nix
      ./modules/development.nix
    ];

  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = import ./pkgs;
  };

  networking.hostName = "${hostName}";

  system.autoUpgrade = {
    enable = true;
    channel = https://nixos.org/channels/nixos-unstable;
  };

  nix.gc.automatic = true;
  nix.gc.dates = "13:15";
}
