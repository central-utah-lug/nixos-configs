{ config, pkgs, ... }:

let
  discordrss = {
    port = 3000;
    image_tag = "v0.10.0";
    redis_image_tag = "7.0.11";
  };
in {
  system.activationScripts.mkdiscordrssNet = ''
    ${pkgs.docker}/bin/docker network create discordrss  &2>/dev/null || true
  '';

  networking.firewall = {
    allowedTCPPorts = [
      discordrss.port
    ];
  };

  # Containers for cal.com
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      discordrss = {
        image = "ghcr.io/3ventic/discord-rss/discord-rss:${discordrss.image_tag}";
        autoStart = true;
        ports = ["${discordrss.port}:${discordrss.port}"];
        environment = {
          PORT = "${discordrss.port}";
          REDIS_URL = "redis://discordrss-redis:6379";
        };
        environmentFiles = [
          /opt/discordrss/discordrss.env
        ];
        volumes = [
          "/opt/discordrss/data:/tmp/appdata"
        ];
        dependsOn = [ "discordrss-redis" ];
        extraOptions = [
          "--network=discordrss"
        ];
      };
      discordrss-redis = {
        image = "docker.io/redis:${discordrss.redis_image_tag}";
        autoStart = true;
        volumes = [
          "/opt/discordrss/redis:/data"
        ];
        extraOptions = [
          "--network=discordrss"
        ];
      };
    };
  };
}
