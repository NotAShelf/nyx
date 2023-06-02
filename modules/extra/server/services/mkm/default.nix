{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkIf;
in {
  virtualisation.oci-containers = {
    backend = "podman";

    containers = {
      "mkm-web" = mkIf (config.networking.hostName == "helios") {
        autoStart = true;
        environmentFiles = [
          /home/notashelf/Dev/mkm-ticketing/.env.local
        ];
        ports = [
          "3000:3001"
          "3306:3306"
        ];
        extraOptions = ["--network=host"];

        image = "mkm-web";
        imageFile = inputs.mkm.packages.${pkgs.system}.dockerImage;
      };
    };
  };
}
