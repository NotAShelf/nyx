{
  config,
  lib,
  inputs',
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.modules.services;
in {
  config = mkIf cfg.mkm.enable {
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
          imageFile = inputs'.mkm.packages.dockerImage;
        };
      };
    };
  };
}
