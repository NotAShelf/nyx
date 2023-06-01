{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkIf getExe;
in {
  virtualisation.oci-containers.containers = mkIf (config.networking.hostName == "helios") {
    "mkm-web" = {
      workdir = "/tmp/mkm-web";
      ports = ["3000:3001"];
      entrypoint = "next dev";
      image = "mkm-web:latest";
      imageFile = with pkgs;
        dockerTools.buildImage {
          name = "mkm-web";
          tag = "latest";

          fromImage = "node:18-alpine";
          # fromImageName = "node";
          # fromImageTag = "18-alpine";

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

          #diskSize = 1024;
          #buildVMMemorySize = 256;

          config = {
            User = "nonroot";
            WorkingDir = "/home/nonroot";
            Entrypoint = ["pnpm run dev"];
          };
        };
    };
  };
}
