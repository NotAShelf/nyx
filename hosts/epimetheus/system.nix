{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkForce optionals;

  dev = config.modules.device;
in {
  config = {
    fileSystems = {
      "/".options = ["compress=zstd" "noatime"];
      "/home".options = ["compress=zstd"];
      "/nix".options = ["compress=zstd" "noatime"];
      "/var/log".options = ["compress=zstd" "noatime"];
      "/persist".options = ["compress=zstd" "noatime"];
    };

    hardware = {
      nvidia = mkIf (builtins.elem dev.gpu ["nvidia" "hybrid-nv"]) {
        nvidiaPersistenced = mkForce false;

        open = mkForce false;

        prime = {
          offload.enable = mkForce true;
          # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
          intelBusId = "PCI:0:2:0";

          # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
          nvidiaBusId = "PCI:1:0:0";
        };
      };
    };

    boot = {
      kernelParams =
        [
          "nohibernate"
          # The passive default severely degrades performance.
          "intel_pstate=active"
        ]
        ++ optionals ((dev.cpu == "intel") && (dev.gpu != "hybrid-nv")) [
          "i915.enable_fbc=1"
          "i915.enable_psr=2"
        ];

      kernelModules = [
        "sdhci" # fix microsd cards
      ];
    };

    services.btrfs.autoScrub = {fileSystems = ["/"];};

    home-manager.users.notashelf.systemd.user.startServices = "legacy";

    console.earlySetup = true;
  };
}
