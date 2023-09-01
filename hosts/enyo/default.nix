{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./mounts.nix
    ./wireguard.nix
    ./style.nix
  ];
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
        boot = {
          loader = "systemd-boot";
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

        autologin = true;

        video.enable = true;
        sound.enable = true;
        bluetooth.enable = false;
        printing.enable = false;
        emulation.enable = true;
        yubikeySupport.enable = true;

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
          tor.enable = true;
          fixWebcam = false;
        };
      };

      usrEnv =
        {
          isWayland = true;
          desktop = "Hyprland";
          useHomeManager = true;
        }
        // {
          programs = import ./usrEnv.nix;
        };
    };

    fileSystems = {
      "/".options = ["compress=zstd" "noatime"];
      "/home".options = ["compress=zstd"];
      "/nix".options = ["compress=zstd" "noatime"];
    };

    console.earlySetup = true;

    services.syncthing.enable = true;
  };
}
