{lib, ...}: {
  config = {
    modules = {
      device = {
        type = "server";
        cpu = null;
        gpu = null;
        hasBluetooth = false;
        hasSound = false;
        hasTPM = false;
      };

      system = {
        username = "notashelf";
        fs = ["btrfs" "vfat" "exfat"];
        video.enable = false;
        sound.enable = false;
        bluetooth.enable = false;
        printing.enable = false;
        virtualization = {
          enable = false;
          qemu.enable = false;
        };

        networking = {
          optimizeTcp = false;
          useTailscale = true;
        };

        security = {
          secureBoot = false;
        };
      };

      usrEnv = {
        useHomeManager = true;
      };

      programs = {
        git.signingKey = "";

        cli.enable = true;
        gui.enable = false;
      };
    };

    zramSwap.enable = true;
    services.openssh.enable = true;
    users.users.root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIABG2T60uEoq4qTZtAZfSBPtlqWs2b4V4O+EptQ6S/ru"
    ];

    services.btrfs.autoScrub.enable = lib.mkForce false;

    boot.loader.grub.enable = true;
    boot.loader.grub.version = 2;
    # boot.loader.grub.efiSupport = true;
    # boot.loader.grub.efiInstallAsRemovable = true;
    # boot.loader.efi.efiSysMountPoint = "/boot/efi";
    # Define on which hard drive you want to install Grub.
    boot.loader.grub.device = "nodev"; # or "nodev" for efi only
  };
}
