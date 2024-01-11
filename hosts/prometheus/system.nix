{
  config,
  lib,
  ...
}: let
  inherit (lib) optionals mkIf mkForce;

  dev = config.modules.device;
in {
  config = {
    fileSystems = {
      "/".options = ["compress=zstd" "noatime"];
      "/home".options = ["compress=zstd"];
      "/nix".options = ["compress=zstd" "noatime"];
    };

    hardware = {
      nvidia = mkIf (builtins.elem dev.gpu ["nvidia" "hybrid-nv"]) {
        open = mkForce false;

        prime = {
          offload.enable = true;
          intelBusId = "PCI:0:2:0";
          nvidiaBusId = "PCI:1:0:0";
        };
      };
    };

    boot = {
      kernelParams = optionals ((dev.cpu == "intel") && (dev.gpu != "hybrid-nv")) [
        "i915.enable_fbc=1"
        "i915.enable_psr=2"
      ];
    };
  };
}
