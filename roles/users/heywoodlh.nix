{ config, pkgs, ... }:

let
  username = "heywoodlh";
  userHome = "/home/${username}";
  cloneDir = "${userHome}/opt/conf";
in {
  users.users.heywoodlh = {
    isNormalUser = true;
    uid = 1000;
    home = "/home/heywoodlh";
    description = "Spencer Heywood";
    extraGroups = [ "wheel" ];
    shell = pkgs.powershell;
    openssh.authorizedKeys.keys = [ 
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC1aOhZI4Uo8jpPnmJe2aalB/HT2n42bo270IVxyRLURrmNrro8y/MEDD55GU9AVieVu2P+W4xBlWYaDJjSngWAh+zV6hrEhCSeGXiRnIZ+dpOBU5gcOFJxOpvSVawmqJFTjFUAdkHSLYuf9dtbasDkbxyyb/8Hh9jFjT0bisSRKi/SEmkh5m4nU7ySa1ltb6htUgQ/Y71Fi09BJWhktiT9HrtL4Gs0wzch9biaH/AFGbRNEnAZgQMAL/zS08IfevR7sYoHyjwVSwWVmA4TOhsm+auu9zPV4WgrnY2BNy+H9tF74AP6s+sf19uQG/2qVS3xcrvw2VhQCwPGHpv0o0tGLaCQBwjmqhbrBzVO4Hy1d/vskxe7Zr6IEEbQTLXTsYo6/yiEXOTzOvN7/V/zzdZkeUdRFGxqIu3EABH5wxNYOMwXNlOjnsxsE5VTovkMeIb+No1itaj1xGXuKBKJzRzKJ9pPLxtiaOimXxG4LYg3Ef50V6JzwT7UxY4DiS3JBUxQSxQ5CxifKRN/pCzUMlsdm+yIoXhy57r6JjFtnzet2Ytz12Vp8vRx6ZNH7upMxMBxmWH0sG7hf7fLjmVuurcL7pIB5U7a5rwUhfTjLUAJSg+DDvaOHyhBUsZp7wRxwoJuctvfxoxSkQtNlimWOwuPQgmNIfjjPQUKwM3j95RZiw== tyranny"
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBPjnAIPI3ypyi8qn8QNlh8jlVxtaZYKRxXjJ1CDWj+Luuv3cbdsmM8V2SeRToeJHCV/qROa8nEnrnFrUqQ3+9qE= chg-mac@secretive.C02GC0NYMD6R.local"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCYn+7oSNHXN3qqDDidw42Vv7fDS0iEpYqaa0wCXRPBlfWAnD81f6dxj/QPGfZtxpl9jvk7nAKpE7RVUvQiJzUC2VM3Bw/4ucT+xliEHo3oesMQQa1AT70VPTbP5PdU7oUpgQWLq39j9XHno2YPJ/WWtuOl/UTjY6IDokkAmNmvft/jqqkiwSkGMmw68qrLFEM7+rNwJV5cXKvvpB6Gqc7qnbJmk1TZ1MRGW5eLjP9ofDqiyoLbnTm7Dw3iHn40GgTcnv5CWGpa0vrKnnLEGrgRB7kR/pyvfsjapkHz0PDvuinQov+MgJfV8B8PHdPC94dsS0DEWJplxhYojtsYa1VZy5zTEMNWICz1QG1yKHN1JQtpbEreHG6DVYvqwnKvK/XN5yiEeiamhD2oKnSh36PexIR0h0AAPO29Ln+anqpRlqJ0nET2CNS04e0vpV4VDJrG6BnyGUQ6CCo7THSq97F4Ne0nY9fpYu5WTFTCh1tTm+nSey0fP/xk22oINl/41VTI/Vk5pNQuuhHUvQupJHw9cD74aKzRddwvgfuAQjPlEuxxsqgFTltTiPF6lZQNeoMIc1OMCRsnl1xNqIepnb7Q5O1CGq+BqtOWh3G4/SPQI5ZUIkOAZegsnPpGWYMrRd7s6LJn5LrBYaY6IvRxmpGOig3tjOUy3fqk7coyTeJXmQ== bitwarden" 
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBBmGLMTS02Ck2EkTTWxGkLp3B+l/6uvxMSlwrQ7gBTojZYnZab4AncwyHyFA08vGXCm/jKOMsyqmNHXQZkmZ4QA= nix-macbook-air@secretive.nix-macbook-air.local"
    ];
  };

  # Allow heywoodlh to run sudo commands without password
  security.sudo.wheelNeedsPassword = false;

  # Dotfiles stuff
  environment.systemPackages = with pkgs; [
    git
    powershell
    peru
  ];
  system.activationScripts.postActivate = ''
    ${pkgs.su}/bin/su ${username} -c "${pkgs.bash}/bin/bash -c '
      PATH=${pkgs.peru}/bin:${pkgs.git}/bin:${pkgs.powershell}/bin:${pkgs.bash}/bin:${pkgs.coreutils}/bin:$PATH
      # Check if the clone directory exists, otherwise clone the repository
      [[ -d ${cloneDir} ]] || ${pkgs.git}/bin/git clone https://github.com/${username}/conf ${cloneDir}

      # Change directory to the clone directory and run the appropriate commands
      cd ${cloneDir} \
      && ${pkgs.peru}/bin/peru sync \
      && ${pkgs.powershell}/bin/pwsh -executionpolicy bypass -file ./setup.ps1
    '"
  '';
}
