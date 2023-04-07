{ lib, pkgs, ... }:

let
  hostname = "generic-server";
in {
  imports = [
    ./hardware-configuration.nix
    ../../roles/server.nix
    ../../roles/docker.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.hostName = "${hostname}"; # Define your hostname

  # Set your time zone.
  time.timeZone = "America/Denver";
  
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  system.stateVersion = "22.11";
}
