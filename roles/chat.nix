{ config, pkgs, ... }:

let
  ssh_alternate_port = 2222;
  sshchat = {
    port = "22";
    image_tag = "1fc7f7b";
  };
in {

  services.openssh = {
    ports = [ ssh_alternate_port ];
    openFirewall = true;
  };

  system.activationScripts.mksshchatNet = ''
    ${pkgs.docker}/bin/docker network create sshchat  &2>/dev/null || true
  '';

  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      sshchat = {
        image = "docker.io/heywoodlh/ssh-chat:${sshchat.image_tag}";
        autoStart = true;
        cmd = [
          "/usr/local/bin/ssh-chat"
          "--identity=/root/.ssh/id_rsa"
          "--admin=/root/.ssh/admin_authorized_keys"
          "--motd=/opt/motd.txt"
        ];
        ports = ["${sshchat.port}:2022"];
        volumes = [
          "/opt/sshchat/ssh:/root/.ssh"
          "/opt/sshchat/motd.txt:/opt/motd.txt"
        ];
        extraOptions = [
          "--network=sshchat"
        ];
      };
    };
  };

  users.users.chat = {
    group = "chat";
    isSystemUser = true;
    uid = 2000;
  };

  services.matterbridge = {
    enable = true;
    user = "chat";
    configPath = "/opt/matterbridge/matterbridge.toml";
  };
}
