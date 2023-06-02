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
        ports = ["3000:3001"];
        entrypoint = "next dev";
        workdir = "/tmp/mkm-web";
        extraOptions = ["--network=host"];

        image = "mkm-web:latest";
        imageFile = with pkgs;
          dockerTools.buildImage {
            config = {
              #User = "nonroot";
              Entrypoint = ["pnpm run dev"];
            };

            name = "mkm-web";
            tag = "latest";

            fromImage = "node:18-alpine";

            copyToRoot = pkgs.buildEnv {
              name = "image-root";
              paths = [
                inputs.mkm.packages.${pkgs.system}.default
                pkgs.nodePackages.pnpm
              ];
              pathsToLink = [
                "/mkm-web"
                "/bin"
              ];
            };

            /*
            runAsRoot = ''
              #!${pkgs.runtimeShell}
              ${pkgs.dockerTools.shadowSetup}
              mkdir /tmp
              chmod 777 -R /tmp
              mkdir -p /usr/bin
              ln -s ${pkgs.coreutils}/bin/env /usr/bin/env
              groupadd -r nonroot
              useradd -r -g nonroot nonroot
              mkdir -p /home/nonroot
              chown nonroot:nonroot /home/nonroot
            '';
            */

            #diskSize = 1024;
            #buildVMMemorySize = 256;
          };
      };
    };
  };
}
