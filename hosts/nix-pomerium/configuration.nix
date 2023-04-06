{ modulesPath, lib, pkgs, ... }:

let
  hostname = "culug-pomerium";
in {
  imports = lib.optional (builtins.pathExists ./do-userdata.nix) ./do-userdata.nix ++ [
    (modulesPath + "/virtualisation/digital-ocean-config.nix")
    ../../roles/server.nix
    ../../roles/pomerium.nix
    ../../roles/docker.nix
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
    systemCronJobs = [
      "0 0 * * Sun      root    /opt/certbot/certbot.sh &> /dev/null"
    ];
  };

  # Enable auto upgrade
  system.autoUpgrade = {
    enable = true;
    flake = "github:central-utah-lug/nixos-configs#${hostname}";
  };

  system.stateVersion = "22.11";
}
