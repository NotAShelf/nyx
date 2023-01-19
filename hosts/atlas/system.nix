{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.device;
in {
  config = {
    modules = {
      device = {
        type = "server";
        cpu = "pi";
        gpu = "pi";
        monitors = ["HDMI-A-1"];
        hasBluetooth = true;
        hasSound = true;
        hasTPM = true;
      };

      system = {
        fs = ["ext4" "vfat"];
        video.enable = true;
        sound.enable = true;
        printing.enable = false;
        bluetooth.enable = false;
        username = "notashelf";
      };

      usrEnv = {
        isWayland = false;
        desktop = [];
        useHomeManager = false;
      };
    };

    environment.systemPackages = with pkgs; [git neovim];
    hardware = {
      # Enable GPU acceleration
      raspberry-pi."4".fkms-3d.enable = true;

      opengl = {
        # this only takes effect in 64 bit systems
        driSupport32Bit = mkForce false;
      };
    };

    boot = {
      kernelModules = lib.mkForce ["bridge" "macvlan" "tap" "tun" "loop" "atkbd" "ctr"];
      supportedFilesystems = lib.mkForce ["btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs" "ext4" "vfat"];
    };

    services = {
      xserver = {
        enable = false;
        displayManager.lightdm.enable = false;
        desktopManager.xfce.enable = false;
      };

      create_ap = {
        enable = true;
        settings = {
          INTERNET_IFACE = "eth0";
          WIFI_IFACE = "wlan0";
          SSID = "Pizone";
          PASSPHRASE = "12345678";
        };
      };
    };

    security.tpm2 = {
      enable = false;
    };

    fileSystems = {
      "/" = {
        device = lib.mkForce "/dev/disk/by-label/NIXOS_SD";
        fsType = "ext4";
        options = ["noatime"];
      };
    };

    hardware = {
      enableRedistributableFirmware = true;
    };
  };
}
