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
        protocol = "ssh-ng";
        hostName = "neushore";
        maxJobs = 4;
        systems = ["aarch64-darwin" "x86_64-darwin" "x86_64-darwin"];
        supportedFeatures = ["benchmark" "big-parallel"];
        publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSU8yelFLRmE0cGI1SE5aM1h3WC93djZoZXdnUWNmbUt1UlBHNFpNazNsbGQgcm9vdEBuZXVzaG9yZQo=";
        sshUser = "notashelf";
        sshKey = "/home/notashelf/.ssh/neushore";
      }
    ];
  };
}
