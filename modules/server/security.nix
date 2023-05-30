{
  config,
  pkgs,
  lib,
  ...
}: {
  services = {
    openssh = {
      enable = true;
      settings = with lib; {
        PermitRootLogin = mkForce "no";
        PasswordAuthentication = mkForce false;
        X11Forwarding = mkDefault false;
      };

      hostKeys = [
        {
          bits = 4096;
          path = "/etc/ssh/ssh_host_rsa_key";
          type = "rsa";
        }
        {
          path = "/etc/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
      ];
    };
  };
}
