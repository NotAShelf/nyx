{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  # TODO: set up service options for nix-server
  # which I may or may not want to use in the future as an alternative to Harmonia
  config = mkIf false {
    /*
    Before enabling this service, you must make sure that a secret key has been generated.
    Run the following commands to generate the key, and paste the contents into an agenix
    secret after setting that up.

    ```
    nix-store --generate-binary-cache-key cache.domain.tld cache-priv-key.pem cache-pub-key.pem
    chown nix-serve cache-priv-key.pem
    cat cache-pub-key.pem
    ```
    */
    services.nix-serve = {
      enable = true;
      openFirewall = true;
      secretKeyFile = config.age.secrets.nix-serve.path;
    };

    services.nginx = {
      virtualHosts."cache.notashelf.dev" =
        {
          locations."/".extraConfig = ''
            proxy_pass http://127.0.0.1:5000;
            proxy_set_header Host $host;
            proxy_redirect http:// https://;
            proxy_http_version 1.1;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection $connection_upgrade;

            zstd on;
            zstd_types application/x-nix-archive;
          '';

          quic = true;
        }
        // lib.sslTemplate;
    };
  };
}
