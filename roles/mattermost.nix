{ config, pkgs, ... }:

{

  networking.firewall.interfaces."ens4".allowedTCPPorts = [
    8065
  ];

  services.mattermost = {
    enable = true;
    siteName = "Central Utah Linux User Group";
    siteUrl = "https://chat.culug.group";
    listenAddress = "0.0.0.0:8065";
  };
}
