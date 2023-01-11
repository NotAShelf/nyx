{modulesPath, ...}: let
  host = "example.org";
  adminEmail = "admin@example.org";
in {
  services.gitlab = rec {
    enable = true;

    inherit host;
    port = 80;

    # You, dear sysadmin, have to make these files exist.
    initialRootPasswordFile = "/tmp/gitlab-secrets/initial-password";

    secrets = rec {
      # A file containing 30 "0" characters.
      secretFile = "/tmp/gitlab-secrets/zeros";
      dbFile = secretFile;
      otpFile = secretFile;
      # openssl genrsa 2048 > jws.rsa
      jwsFile = "/tmp/gitlab-secrets/jws.rsa";
    };
  };

  services.nginx = {
    enable = true;
    user = "gitlab";
    virtualHosts = {
      "${host}" = {
        locations."/" = {
          # http://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_pass
          proxyPass = "http://unix:/var/gitlab/state/tmp/sockets/gitlab.socket";
        };
      };
    };
  };

  networking.firewall = {
    enable = true;
    allowPing = false;
    allowedTCPPorts = [
      22
      80
    ];
  };
}
