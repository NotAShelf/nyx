{
  config,
  lib,
  pkgs,
  ...
}: {
  nix = {
    distributedBuilds = false;
    buildMachines = lib.filter (x: x.hostName != config.networking.hostName) [
      {
        system = "x86_64-linux";
        systems = ["aarch64-darwin" "x86_64-darwin" "x86_64-linux" "aarch64-linux"];
        sshUser = "raf";
        sshKey = "/home/notashelf/.ssh/builder";
        maxJobs = 16;
        hostName = "build.neushore.dev";
        supportedFeatures = ["nixos-test" "benchmark" "kvm" "big-parallel"];
      }
      {
        system = "x86_64-linux";
        systems = ["aarch64-darwin" "x86_64-darwin" "x86_64-linux" "aarch64-linux"];
        sshUser = "notashelf";
        sshKey = "/home/notashelf/.ssh/builder";
        maxJobs = 4;
        hostName = "epimetheus";
        supportedFeatures = ["nixos-test" "benchmark" "kvm" "big-parallel"];
      }
    ];
  };
}
