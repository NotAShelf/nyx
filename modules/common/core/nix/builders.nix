{
  config,
  lib,
  ...
}: let
  builder = {
    systems = ["x86_64-linux" "i686-linux"];
    speedFactor = 4;
    maxJobs = 4;
    supportedFeatures = ["benchmark" "nixos-test"];
    sshKey = config.age.secrets.nix-builderKey.path;
    protocol = "ssh-ng";
  };
  bigBuilder =
    builder
    // {
      maxJobs = 16;
      speedFactor = 16;
      supportedFeatures = builder.supportedFeatures ++ ["kvm" "big-parallel"];
      systems = builder.systems ++ ["aarch64-linux"];
    };
in {
  nix = {
    distributedBuilds = true;
    buildMachines = lib.filter (x: x.hostName != config.networking.hostName) [
      /*
      (bigBuilder
        // {
          sshUser = "builder";
          hostName = "builder";
          protocol = "ssh";
        })
      */
      (bigBuilder
        // {
          sshUser = "nix-builder";
          hostName = "enyo";
        })

      (builder
        // {
          sshUser = "nix-builder";
          hostName = "helios";
        })
      (builder
        // {
          sshUser = "nix-builder";
          hostName = "epimetheus";
        })
      (builder
        // {
          sshUser = "nix-builder";
          hostName = "hermes";
        })
      (builder
        // {
          sshUser = "nix-builder";
          hostName = "icarus";
        })
    ];
  };
}
