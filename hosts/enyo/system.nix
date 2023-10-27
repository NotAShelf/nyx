{
  lib,
  pkgs,
  ...
}: {
  config = {
    modules = {
      device = {
        type = "desktop";
        cpu = "amd";
        gpu = "amd";
        monitors = ["DP-1" "HDMI-A-1"];
        hasBluetooth = true;
        hasSound = true;
        hasTPM = true;
      };

      system = {
        mainUser = "notashelf";
        fs = ["btrfs" "vfat" "ntfs" "exfat"];
        autoLogin = true;

        boot = {
          loader = "systemd-boot";
          secureBoot = false;
          kernel = pkgs.linuxPackages_xanmod_latest;
          enableKernelTweaks = true;
          enableInitrdTweaks = true;
          loadRecommendedModules = true;
          tmpOnTmpfs = true;
          plymouth = {
            enable = true;
            withThemes = false;
          };
        };

        yubikeySupport.enable = true;

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
          tor.enable = true;
          fixWebcam = false;
          lockModules = true;
          auditd.enable = true;
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
          chess.enable = true;
        };
        default = {
          terminal = "foot";
        };
        override = {
          libreoffice = false;
        };
      };
    };

    fileSystems = {
      "/".options = ["compress=zstd" "noatime"];
      "/nix".options = ["compress=zstd" "noatime"];
      "/var/log".options = ["compress=zstd" "noatime"];
      "/home".options = ["compress=zstd"];
    };

    console.earlySetup = true;

    services.syncthing.enable = false;
  };
}
