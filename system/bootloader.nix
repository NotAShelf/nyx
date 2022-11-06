{
  config,
  pkgs,
  lib,
  ...
}: {
  boot = {
    plymouth.enable = true;
    loader = {
      systemd-boot.enable = lib.mkDefault false;
      grub = {
        enable = lib.mkDefault true;
        useOSProber = true;
        efiSupport = true;
        enableCryptodisk = false;
        device = "nodev";
        theme = null;
        backgroundColor = null;
        splashImage = null;
      };
    };

    cleanTmpDir = true;

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

    extraModulePackages = with config.boot.kernelPackages; [acpi_call];
    extraModprobeConfig = "options hid_apple fnmode=1";

    # Change default bootloader to grub
    loader = {
      efi.canTouchEfiVariables = true;
      timeout = 1;
    };

    initrd.verbose = false;
    initrd = {
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
        "usb_storage"
        "rtsx_pci_sdmmc"
      ];
    };
  };
}
