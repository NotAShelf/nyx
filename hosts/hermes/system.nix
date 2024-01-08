{
  config,
  pkgs,
  ...
}: {
  config = {
    modules = {
      device = {
        type = "laptop";
        cpu = {
          type = "amd";
          amd.pstate.enable = true;
          amd.zenpower.enable = true;
        };
        gpu.type = "amd";
        monitors = ["eDP-1"];
        hasBluetooth = true;
        hasSound = true;
        hasTPM = true;
      };
      system = {
        mainUser = "notashelf";
        fs = ["btrfs" "ext4" "vfat"];
        impermanence.root.enable = true;

        boot = {
          secureBoot = false;
          plymouth.enable = true;
          loader = "systemd-boot";
          enableKernelTweaks = true;
          initrd.enableTweaks = true;
          loadRecommendedModules = true;
          tmpOnTmpfs = true;
        };

        encryption = {
          enable = true;
          device = "enc";
        };

        yubikeySupport.enable = true;
        autoLogin = true;

        video.enable = true;
        sound.enable = true;
        bluetooth.enable = true;
        printing.enable = true;
        emulation.enable = true;

        networking = {
          optimizeTcp = true;
          nftables.enable = true;
          tailscale = {
            enable = true;
            isClient = true;
          };
        };

        security = {
          fixWebcam = false;
          lockModules = true;
          usbguard.enable = true;
        };

        virtualization = {
          enable = true;
          docker.enable = true;
          qemu.enable = false;
          podman.enable = false;
        };
      };

      usrEnv = {
        isWayland = true;
        desktop = "Hyprland";
        useHomeManager = true;
      };

      programs = {
        git.signingKey = "0x02D1DD3FA08B6B29";

        cli.enable = true;
        gui.enable = true;

        gaming = {
          enable = true;
          chess.enable = false;
        };
        default = {
          terminal = "foot";
        };
        override = {};
      };
    };

    fileSystems = {
      "/".options = ["compress=zstd" "noatime"];
      "/home".options = ["compress=zstd"];
      "/nix".options = ["compress=zstd" "noatime"];
      "/var/log".options = ["compress=zstd" "noatime"];
      "/persist".options = ["compress=zstd" "noatime"];
    };

    # fingerprint login
    # doesn't work because thanks drivers
    services.fprintd = {
      enable = false;
      tod.enable = true;
      tod.driver = pkgs.libfprint-2-tod1-goodix;
    };

    security.pam.services = {
      login.fprintAuth = true;
      swaylock.fprintAuth = true;
    };

    console.earlySetup = true;
  };
}
