{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib; let
  device = config.modules.device;
in {
  config = mkIf (device.type == "server") {
    boot = {
      loader = {
        systemd-boot.enable = false;
        grub = {
          enable = lib.mkForce true;
          useOSProber = true;
          efiSupport = true;
          enableCryptodisk = false;
          device = "nodev";
          theme = null;
          backgroundColor = null;
          splashImage = null;
        };
      };

      tmp.cleanOnBoot = true;

      # some kernel parameters, i dont remember what half of this shit does but who cares
      kernelParams = [
        "acpi_call"
        "pti=on"
        "randomize_kstack_offset=on"
        "vsyscall=none"
        "slab_nomerge"
        "debugfs=on" # needs to be on for powertop
        "module.sig_enforce=1"
        "lockdown=confidentiality"
        "page_poison=1"
        "page_alloc.shuffle=1"
        "slub_debug=FZP"
        "sysrq_always_enabled=1"
        "processor.max_cstate=5"
        "idle=nomwait"
        "rootflags=noatime"
        "iommu=pt"
        "usbcore.autosuspend=-1"
        "sysrq_always_enabled=1"
        "lsm=landlock,lockdown,yama,apparmor,bpf"
        "loglevel=7"
        "rd.udev.log_priority=3"
      ];

      consoleLogLevel = 0;

      # switch from old ass lts kernel
      kernelPackages = pkgs.linuxPackages_latest;

      extraModulePackages = [];
      extraModprobeConfig = "options hid_apple fnmode=1";

      initrd = {
        verbose = false;
        availableKernelModules = [
          "nvme"
          "usbhid"
          "sd_mod"
          "dm_mod"
          "tpm"
        ];
        kernelModules = [
          "xhci_pci"
          "ahci"
          "btrfs"
          "kvm-intel"
          "sd_mod"
          "dm_mod"
          "rtsx_pci_sdmmc"
        ];
      };
    };
  };
}
