{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  dev = config.modules.device;

  kver = config.boot.kernelPackages.kernel.version;
in {
  config = mkIf (dev.cpu == "amd" || dev.cpu == "vm-amd") {
    hardware.cpu.amd.updateMicrocode = true;
    boot = lib.mkMerge [
      {
        kernelModules = [
          "kvm-amd"
          "amd-pstate" # load pstate module in case the device has a newer gpu
          "zenpower"
        ];
        extraModulePackages = with config.boot.kernelPackages; [zenpower];
      }

      (lib.mkIf ((lib.versionAtLeast kver "5.17") && (lib.versionOlder kver "6.1")) {
        kernelParams = ["initcall_blacklist=acpi_cpufreq_init"];
        kernelModules = ["amd-pstate"];
      })

      (lib.mkIf ((lib.versionAtLeast kver "6.1") && (lib.versionOlder kver "6.3")) {
        kernelParams = ["amd_pstate=passive"];
      })

      # for older kernels, see https://github.com/NixOS/nixos-hardware/blob/c256df331235ce369fdd49c00989fdaa95942934/common/cpu/amd/pstate.nix
      (lib.mkIf
        (lib.versionAtLeast kver "6.3") {
          kernelParams = ["amd_pstate=active"];
        })
    ];

    # cpu power control
    # we can enable undervolting unconditionally, but I would like a condition nevertheless
    /*
    systemd.services.zenstates = {
      enable = true;
      description = "Ryzen Undervolt";
      after = ["syslog.target" "systemd-modules-load.service"];

      unitConfig = {ConditionPathExists = "${pkgs.zenstates}/bin/zenstates";};

      serviceConfig = {
        User = "root";
        ExecStart = "${pkgs.zenstates}/bin/zenstates ${value}";
      };

      wantedBy = ["multi-user.target"];
    };
    */
  };
}
