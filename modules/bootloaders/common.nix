{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  boot = {
    binfmt.emulatedSystems = [
      "aarch64-linux"
    ];

    loader = {
      # Fix a security hole in place for backwards compatibility. See desc in
      # nixpkgs/nixos/modules/system/boot/loader/systemd-boot/systemd-boot.nix
      systemd-boot.editor = false;

      # could be a little faster
      # TODO: actually benchmark the boot process to see if it's worth it
      generationsDir.copyKernels = true;

      systemd-boot = {
        enable = lib.mkDefault true;
        configurationLimit = 5;
      };

      # allow installation to modify EFI variables
      efi.canTouchEfiVariables = true;

      # if set to 0, space needs to be held to get the boot menu to appear
      timeout = 2;

      # default grub to disabled, we manually enable grub on "server" hosts
      grub = {
        # if need be, this value can be overriden in individual hosts
        # @ hosts/hostname/system.nix
        enable = lib.mkDefault false;
        useOSProber = true;
        efiSupport = true;
        enableCryptodisk = false;
        device = "nodev";
        theme = null;
        backgroundColor = null;
        splashImage = null;
      };
    };

    tmpOnTmpfs = lib.mkDefault true;

    # If not using tmpfs, which is naturally purged on reboot, we must clean it
    # /tmp ourselves. /tmp should be volatile storage!
    cleanTmpDir = lib.mkDefault (!config.boot.tmpOnTmpfs);

    # some kernel parameters, i dont remember what half of this shit does but who cares
    # TODO: document what each of those params do
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
      "noresume"
      # allows systemd to set and save the backlight state
      "acpi_backlight=none"
      # prevent the kernel from blanking plymouth out of the fb
      "fbcon=nodefer"
      # disable boot logo if any
      "logo.nologo"
      # tell the kernel to not be verbose
      "quiet"
      # disable systemd status messages
      "rd.systemd.show_status=auto"
      # lower the udev log level to show only errors or worse
      "rd.udev.log_level=3"
      # disable the cursor in vt to get a black screen during intermissions
      # TODO turn back on in tty
      "vt.global_cursor_default=0"
    ];

    consoleLogLevel = 0;

    # switch from old ass lts kernel
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

    extraModulePackages = with config.boot.kernelPackages; [acpi_call];
    extraModprobeConfig = "options hid_apple fnmode=1";

    initrd = {
      verbose = false;

      # strip copied binaries and libraries from inframs
      # saves 30~ mb space according to the nix derivation
      systemd.strip = true;

      # TODO: figure out why the hell this breaks plymouth
      # extremely experimental, just the way I like it on a production machine
      #systemd.enable = true;

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
