{
  config,
  lib,
  ...
}: let
  inherit (builtins) elem;
  inherit (lib.modules) mkIf mkForce;
  inherit (lib.lists) optionals;

  dev = config.modules.device;
in {
  imports = [
    ./fs
    ./modules
  ];

  config = {
    hardware = {
      nvidia = mkIf (elem dev.gpu ["nvidia" "hybrid-nv"]) {
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
