{
  pkgs,
  lib,
  config,
  ...
}: {
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
}
