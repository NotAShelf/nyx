{
  config,
  pkgs,
  lib,
  ...
}: {
  services = {
    openssh = {
      enable = true;
      permitRootLogin = lib.mkForce "no";
      openFirewall = true;
      forwardX11 = false;
      ports = [22];
      passwordAuthentication = lib.mkForce false;
      hostKeys = [
        {
          bits = 4096;
          path = "/etc/ssh/ssh_host_rsa_key";
          type = "rsa";
        }
        {
          path = "/etc/ssh(ssh_host_ed25519_key";
          type = "ed25519";
        }
      ];
      extraConfig = ''
        Match User git
          AuthorizedKeysCommandUser git
          AuthorizedKeysCommand ${pkgs.gitea}/bin/gitea keys -e git -u %U -t %T -k %k
        Match all
      '';
    };

    fail2ban = {
      enable = true;
      maxretry = 5;
      ignoreIP = [
        "127.0.0.0/8"
        "10.0.0.0/8"
      ];
    };
  };

  security = {
    acme = {
      acceptTerms = true;
      defaults.email = "me@notashelf.dev";
      certs."notashelf.dev" = {
        group = "nginx";
        email = "me@notashelf.dev";
      };
    };
  };
}
