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
        hasTPM = false;
      };
      system = {
        fs = ["ext4" "vfat"];
        video.enable = true;
        sound.enable = true;
        bluetooth.enable = false;
        printing.enable = false;
        virtualization.enable = false;
        username = "notashelf";
      };
      usrEnv = {
        isWayland = false;
        desktop = "Hyprland";
        useHomeManager = true;
      };
      programs = {
        git.signingKey = "0x84184B8533918D88";

        cli.enable = true;
        gui.enable = false;

        gaming = {
          enable = false;
          chess.enable = false;
        };

        default = {
          terminal = "foot";
        };

        override = {};
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
      loader.grub.enable = mkForce false;
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
