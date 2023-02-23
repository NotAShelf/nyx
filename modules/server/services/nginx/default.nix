{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  device = config.modules.devicece;
  acceptedTypes = ["server" "hybrid"];

  mkWellKnown = data: ''
    add_header Content-Type application/json;
    add_header Access-Control-Allow-Origin *;
    return 200 '${builtins.toJSON data}';
  '';
  fqdn = "${config.networking.hostName}.${config.networking.domain}";
  serverConfig."m.server" = "${config.services.matrix-synapse.settings.server_name}:443";
in {
  config = mkIf (builtins.elem device.type acceptedTypes) {
    nixpkgs.overlays = [
      (final: super: {
        nginxStable = super.nginxStable.override {openssl = super.pkgs.libressl;};
      })
    ];

    networking.domain = "notashelf.dev";

    nginx = {
      enable = true;
      recommendedTlsSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;
      virtualHosts = {
        "notashelf.dev" = {
          addSSL = true;
          serverAliases = ["www.notashelf.dev"];
          enableACME = true;
          #extraConfig = "error_page 404 /404.html;"; # nextjs handles 404 pages itself - can nix handle nextjs?
          locations."= /.well-known/matrix/server".extraConfig = mkWellKnown serverConfig;
          locations."= /.well-known/matrix/client".extraConfig = mkWellKnown clientConfig;
        };
      };
    };
  };
}
