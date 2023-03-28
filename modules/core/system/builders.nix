{
  config,
  lib,
  pkgs,
  ...
}: {
  nix = {
    settings = {
      builders-use-substitutes = true;
    };
    distributedBuilds = true;
    buildMachines = [
      {
        protocol = "ssh";
        hostName = "build.neushore.dev";
        maxJobs = 4;
        systems = ["aarch64-darwin" "x86_64-darwin" "x86_64-linux"];
        system = "x86_64-linux";
        supportedFeatures = ["benchmark" "big-parallel" "kvm"];
        publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSU8yelFLRmE0cGI1SE5aM1h3WC93djZoZXdnUWNmbUt1UlBHNFpNazNsbGQgcm9vdEBuZXVzaG9yZQo=";
        sshUser = "raf";
        sshKey = "/home/notashelf/.ssh/builder";
      }
    ];
  };
}
