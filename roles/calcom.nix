{ config, pkgs, ... }:

let
  interface = "shadow";
  calcom = {
    port = "80";
    image_tag = "v2.7.6";
    postgres_image_tag = "15.2";
  };
in {
  system.activationScripts.mkcalcomNet = ''
    ${pkgs.docker}/bin/docker network create calcom  &2>/dev/null || true
  '';

  # Containers for cal.com
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      calcom = {
        image = "docker.io/calcom/cal.com:${calcom.image_tag}";
        autoStart = true;
        ports = ["${calcom.port}:3000"];
        environmentFiles = [
          /opt/calcom/calcom.env
        ];
        dependsOn = [ "calcom-postgres" ];
        extraOptions = [
          "--network=calcom"
        ];
      };
      calcom-postgres = {
        image = "docker.io/postgres:${calcom.postgres_image_tag}";
        autoStart = true;
        environmentFiles = [
          /opt/calcom/calcom.env
        ];
        volumes = [
          "/opt/calcom/db:/var/lib/postgresql/data"
        ];
        extraOptions = [
          "--network=calcom"
        ];
      };
    };
  };
}
