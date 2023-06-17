{pkgs, ...}: {
  config = {
    modules = {
      device = {
        type = "desktop";
        cpu = "amd";
        gpu = "amd";
        monitors = ["HDMI-A-1"];
        hasBluetooth = true;
        hasSound = true;
        hasTPM = true;
        yubikeySupport.enable = true;
      };

      system = {
        username = "notashelf";
        fs = ["btrfs" "vfat" "ntfs" "exfat"];

        boot = {
          loader = "systemd-boot";
          enableKernelTweaks = true;
          enableInitrdTweaks = true;
          loadRecommendedModules = true;
          tmpOnTmpfs = true;
        };

        video.enable = true;
        sound.enable = true;
        bluetooth.enable = false;
        printing.enable = false;
        emulation.enable = true;

        virtualization = {
          enable = true;
          qemu.enable = true;
          docker.enable = true;
        };

        networking = {
          optimizeTcp = true;
          useTailscale = true;
        };

        security = {
          secureBoot = false;
        };
      };

      usrEnv = {
        isWayland = true;
        desktop = "Hyprland";
        useHomeManager = true;
        autologin = true;
      };

      programs = {
        git.signingKey = "0x4CAB619FB7C0D6C4";

        cli.enable = true;
        gui.enable = true;

        gaming = {
          enable = true;
          chess.enable = true;
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
    };

    boot = {
      kernelPackages = pkgs.linuxPackages_xanmod_latest;

      kernelParams = [
        "nohibernate"
      ];
    };

    console.earlySetup = true;
  };
}
