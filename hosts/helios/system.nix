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

    boot.loader.grub = {
      enable = true;
      version = 2;
      useOSProber = lib.mkForce false;
      efiSupport = true;
      enableCryptodisk = false;
      theme = null;
      backgroundColor = null;
      splashImage = null;
      device = lib.mkForce "/dev/sda";
    };
  };
}
