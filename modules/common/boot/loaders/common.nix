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
  # the "common" module is for all devices except servers
  # TODO: possible override option
  config = mkIf (device.type != "server") {
    boot = {
      loader = {
        # Fix a security hole in place for backwards compatibility. See desc in
        # nixpkgs/nixos/modules/system/boot/loader/systemd-boot/systemd-boot.nix
        systemd-boot.editor = false;

        generationsDir.copyKernels = true;

        systemd-boot = {
          enable = mkDefault true;
          configurationLimit = null;
          consoleMode = "max";
        };

        # allow installation to modify EFI variables
        efi.canTouchEfiVariables = true;

        # if set to 0, space needs to be held to get the boot menu to appear
        timeout = mkForce 2;

        # default grub to disabled, we manually enable grub on "server" hosts
        # or any other host that needs it
        grub = {
          # if need be, this value can be overriden in individual hosts
          # @ hosts/<hostname>/system.nix
          enable = mkDefault false;
          useOSProber = true;
          efiSupport = true;
          enableCryptodisk = mkDefault false;
          device = "nodev";
          theme = null;
          backgroundColor = null;
          splashImage = null;
        };
      };

      tmp = {
        # /tmp on tmpfs, lets it live on your ram
        useTmpfs = mkDefault true;

        # If not using tmpfs, which is naturally purged on reboot, we must clean
        # /tmp ourselves. /tmp should be volatile storage!
        cleanOnBoot = mkDefault (!config.boot.tmp.useTmpfs);
      };

      # https://www.kernel.org/doc/html/v4.14/admin-guide/kernel-parameters.html
      kernelParams = [
        # enables calls to ACPI methods through /proc/acpi/call
        "acpi_call"

        # https://en.wikipedia.org/wiki/Kernel_page-table_isolation
        "pti=on"

        # make stack-based attacks on the kernel harder
        "randomize_kstack_offset=on"

        # this has been defaulted to none back in 2016 - break really old binaries for security
        "vsyscall=none"

        # https://tails.boum.org/contribute/design/kernel_hardening/
        "slab_nomerge"

        # needs to be on for powertop
        "debugfs=on"

        # only allow signed modules
        "module.sig_enforce=1"

        # blocks access to all kernel memory, even preventing administrators from being able to inspect and probe the kernel
        "lockdown=confidentiality"

        # enable buddy allocator free poisoning
        "page_poison=1"

        # performance improvement for direct-mapped memory-side-cache utilization, reduces the predictability of page allocations
        "page_alloc.shuffle=1"

        # WARNING: this will leak unhashed memory addresses to dmesg
        # for debugging kernel-level slab issues
        # "slub_debug=FZP"

        # always-enable sysrq keys. Useful for debugging
        "sysrq_always_enabled=0"

        # save power on idle by limiting c-states
        # https://gist.github.com/wmealing/2dd2b543c4d3cff6cab7
        "processor.max_cstate=5"

        # disable the intel_idle driver and use acpi_idle instead
        "idle=nomwait"

        # ignore access time (atime) updates on files, except when they coincide with updates to the ctime or mtime
        "rootflags=noatime"

        # enable IOMMU for devices used in passthrough and provide better host performance
        "iommu=pt"

        # disable usb autosuspend
        "usbcore.autosuspend=-1"
        # linux security modules
        "lsm=landlock,lockdown,yama,apparmor,bpf"

        # 7 = KERN_DEBUG for debugging
        "loglevel=7"

        # isables resume and restores original swap space
        "noresume"

        # allows systemd to set and save the backlight state
        "acpi_backlight=native" # none | vendor | video | native

        # prevent the kernel from blanking plymouth out of the fb
        "fbcon=nodefer"

        # disable boot logo if any
        "logo.nologo"

        # tell the kernel to not be verbose
        # "quiet"

        # disable systemd status messages
        # rd prefix means systemd-udev will be used instead of initrd
        "rd.systemd.show_status=auto"

        # lower the udev log level to show only errors or worse
        "rd.udev.log_level=3"

        # disable the cursor in vt to get a black screen during intermissions
        # TODO turn back on in tty
        "vt.global_cursor_default=0"
      ];

      consoleLogLevel = 0;

      # always use the latest kernel instead of the old-ass lts one
      kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

      extraModulePackages = with config.boot.kernelPackages; [acpi_call];
      extraModprobeConfig = "options hid_apple fnmode=1";

      initrd = {
        verbose = false;

        # strip copied binaries and libraries from inframs
        # saves 30~ mb space according to the nix derivation
        systemd.strip = true;

        # extremely experimental, just the way I like it on a production machine
        systemd.enable = true;

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
          "sd_mod"
          "dm_mod"
          "usb_storage"
          "rtsx_pci_sdmmc"
        ];
      };
    };
  };
}