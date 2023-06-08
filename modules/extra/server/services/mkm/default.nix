{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.modules.services.override;
in {
  config = mkIf (!cfg.mkm) {
    virtualisation.oci-containers = {
      backend = "podman";
      containers = {
        "mkm-web" = mkIf (config.networking.hostName == "helios") {
          autoStart = true;
          environmentFiles = [
            config.age.secrets.mkm-web.path
          ];
          ports = [
            "3005:3005"
            "3306:3306"
          ];
          extraOptions = ["--network=host"];

          image = "mkm-web";
          imageFile = inputs.mkm.packages.${pkgs.system}.dockerImage;
        };
      };
    };
  };
}
