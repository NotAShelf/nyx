{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  device = config.modules.devicece;
  acceptedTypes = ["server" "hybrid"];
in {
  config = mkIf (builtins.elem device.type acceptedTypes) {
    nixpkgs.overlays = [
      (final: super: {
        nginxStable = super.nginxStable.override {openssl = super.pkgs.libressl;};
      })
    ];

    nginx = {
      enable = true;
      recommendedTlsSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;
      virtualHosts = {
        # TODO: define virtual hosts at services own files
        #"notashelf.dev" = {
        #  addSSL = true;
        #  serverAliases = ["www.notashelf.dev"];
        #  enableACME = true;
        #  root = "/srv/www/notashelf.dev";
        #};

        #"git.notashelf.dev" = {
        #  addSSL = true;
        #  enableACME = true;
        #  locations."/" = {
        #    proxyPass = "http://localhost:7000/";
        #  };
        #};
      };
    };
  };
}
