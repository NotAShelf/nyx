{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) isx86Linux;
  inherit (lib.modules) mkIf mkMerge;
  inherit (lib.strings) versionOlder versionAtLeast;
  dev = config.modules.device;

  kver = config.boot.kernelPackages.kernel.version;
  inherit (dev.cpu.amd) pstate zenpower;
in {
  config = mkIf (builtins.elem dev.cpu.type ["amd" "vm-amd"]) {
    environment.systemPackages = [pkgs.amdctl];

    hardware.cpu.amd.updateMicrocode = true;
    boot = mkMerge [
      {
        # Always load the kvm-amd module for Virtualization
        # bellow modules allow for Virtualization on AMD cpus
        # `"iommu=pt"` kernel parameter can be passed to remove
        # IOMMU overhead
        kernelModules = ["kvm-amd"];
        kernelParams = ["amd_iommu=on"];
      }

      (mkIf (isx86Linux pkgs) {
        kernelModules = [
          "amd-pstate" # load pstate module in case the device has a newer gpu
          "zenpower" # zenpower is for reading cpu info, i.e voltage
          "msr" # x86 CPU MSR access device
        ];

        extraModulePackages = [config.boot.kernelPackages.zenpower];
      })

      (mkIf (pstate.enable && (versionAtLeast kver "5.17") && (versionOlder kver "6.1")) {
        kernelParams = ["initcall_blacklist=acpi_cpufreq_init"];
        kernelModules = ["amd-pstate"];
      })

      (mkIf (pstate.enable && (versionAtLeast kver "6.1") && (versionOlder kver "6.3")) {
        kernelParams = ["amd_pstate=passive"];
      })

      # For older kernels.
      # See:
      #  <https://github.com/NixOS/nixos-hardware/blob/c256df331235ce369fdd49c00989fdaa95942934/common/cpu/amd/pstate.nix>
      (mkIf (pstate.enable && (versionAtLeast kver "6.3")) {
        kernelParams = ["amd_pstate=active"];
      })
    ];

    # Ryzen cpu control
    systemd.services.zenstates = mkIf zenpower.enable {
      enable = true;
      description = "Undervolt via Zenstates";
      after = ["syslog.target" "systemd-modules-load.service"];

      unitConfig = {ConditionPathExists = "${pkgs.zenstates}/bin/zenstates";};

      serviceConfig = {
        User = "root";
        ExecStart = "${pkgs.zenstates}/bin/zenstates ${zenpower.args}";
      };

      wantedBy = ["multi-user.target"];
    };
  };
}
