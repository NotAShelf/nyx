{
  config,
  lib,
  ...
}: {
  config = {
    modules = {
      device = {
        type = "server";
        cpu.type = "amd";
        gpu.type = null;
        hasBluetooth = false;
        hasSound = false;
        hasTPM = false;
      };

      system = {
        mainUser = "notashelf";
        fs = ["vfat" "exfat" "ext4"];
        video.enable = false;
        sound.enable = false;
        bluetooth.enable = false;
        printing.enable = false;

        boot = {
          secureBoot = false;
          loader = "grub";
          enableKernelTweaks = true;
          initrd.enableTweaks = true;
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
          tarpit.enable = true;
          tailscale = {
            enable = true;
            isServer = true;
            isClient = false;
          };
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

    services.smartd.enable = lib.mkForce false;

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
        device = lib.mkForce "/dev/disk/by-label/nixos";
        forceInstall = true;
      };
    };

    networking.domain = "notashelf.dev";
  };
}
