{ config, pkgs, ... }:

{

  imports = [
    ./users/heywoodlh.nix
  ];

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
    # For Mosh
    allowedUDPPortRanges = [
      { from = 60000; to = 61000; }
    ];
  };

  services.openssh = {
    enable = true;
    sftpServerExecutable = "internal-sftp";
    settings.PermitRootLogin = "prohibit-password";
    settings.PasswordAuthentication = false;
  };

  environment.systemPackages = with pkgs; [
    git
    htop
    mosh
    vim
  ];
}
