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
        ports = [
          "3000:3001"
          "3306:3306"
        ];
        entrypoint = "next dev";
        workdir = "/tmp/mkm-web";
        extraOptions = ["--network=host"];

        image = "mkm-web";
        imageFile = inputs.mkm.packages.${pkgs.system}.dockerImage;
      };
    };
  };
}
