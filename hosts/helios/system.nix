{
  config,
  lib,
  ...
}: {
  config = {
    modules = {
      device = {
        type = "server";
        cpu = "amd";
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

        boot = {
          loader = "grub";
          enableKernelTweaks = true;
          enableInitrdTweaks = true;
          loadRecommendedModules = true;
          tmpOnTmpfs = false;
        };

        virtualization = {
          enable = true;
          qemu.enable = true;
          docker.enable = true;
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
        isWayland = false;
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

    boot = {
      growPartition = !config.boot.initrd.systemd.enable;
      kernel = {
        sysctl = {
          # # Enable IP forwarding
          # required for Tailscale subnet feature
          # https://tailscale.com/kb/1019/subnets/?tab=linux#step-1-install-the-tailscale-client
          # also wireguard
          "net.ipv4.ip_forward" = true;
          "net.ipv6.conf.all.forwarding" = true;
        };
      };

      loader.grub = {
        enable = true;
        useOSProber = lib.mkForce false;
        efiSupport = lib.mkForce false;
        enableCryptodisk = false;
        theme = null;
        backgroundColor = null;
        splashImage = null;
        device = lib.mkForce "/dev/sda";
      };
    };

    networking.domain = "notashelf.dev";
  };
}
