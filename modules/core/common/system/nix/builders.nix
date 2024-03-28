{
  config,
  lib,
  ...
}: let
  inherit (lib.attrsets) recursiveUpdate;
  inherit (lib.lists) filter;
  # a generic builder configuration
  builder = {
    systems = ["x86_64-linux"];
    speedFactor = 4;
    maxJobs = 4;
    supportedFeatures = ["benchmark" "nixos-test"];
    sshKey = "/home/notashelf/.ssh/builder";
    protocol = "ssh-ng";
  };

  # override generic config builder with the assumption that more
  # resources and features are available to us
  bigBuilder = recursiveUpdate builder {
    maxJobs = 16;
    speedFactor = 16;
    supportedFeatures = builder.supportedFeatures ++ ["kvm" "big-parallel"];
    systems = builder.systems ++ ["aarch64-linux" "i686-linux"];
  };

  mkBuilder = {
    builderBase ? builder,
    sshProtocol ? "ssh-ng",
    user ? "root",
    host,
    ...
  }:
    recursiveUpdate builderBase {
      hostName = host;
      sshUser = user;
      protocol = sshProtocol;
    };
in {
  nix = {
    distributedBuilds = true;
    buildMachines = filter (builder: builder.hostName != config.networking.hostName) [
      # large build machine
      (mkBuilder {
        builderBase = bigBuilder;
        user = "builder";
        host = "build.neushore.dev";
        sshProtocol = "ssh"; # ssh-ng is not supported by this device
      })
    ];
  };
}
