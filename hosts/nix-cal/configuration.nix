{ modulesPath, lib, pkgs, ... }:

let
  hostname = "culug-cal";
in {
  imports = lib.optional (builtins.pathExists ./do-userdata.nix) ./do-userdata.nix ++ [
    (modulesPath + "/virtualisation/digital-ocean-config.nix")
    ../../roles/server.nix
    ../../roles/docker.nix
    ../../roles/calcom.nix
  ];

  networking.hostName = "${hostname}"; # Define your hostname

  # Set your time zone.
  time.timeZone = "America/Denver";
  
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  # Set crons
  # Enable cron service
  services.cron = {
    enable = true;
  };

  # Enable auto upgrade
  system.autoUpgrade = {
    enable = true;
    flake = "github:central-utah-lug/nixos-configs#${hostname}";
  };

  system.stateVersion = "22.11";
}
