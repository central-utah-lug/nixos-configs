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
    settings.permitRootLogin = "prohibit-password";
    settings.PasswordAuthentication = false;
  };

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 1d";
  }; 

  environment.systemPackages = with pkgs; [
    git
    htop
    mosh
    vim
  ];
}
