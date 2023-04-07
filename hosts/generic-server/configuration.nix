{ lib, pkgs, ... }:

let
  hostname = "generic-server";
in {
  imports = [
    ./hardware-configuration.nix
    ../../roles/server.nix
    ../../roles/docker.nix
  ];

  networking.hostName = "${hostname}"; # Define your hostname

  # Set your time zone.
  time.timeZone = "America/Denver";
  
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  system.stateVersion = "22.11";
}
