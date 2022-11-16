{
  config,
  pkgs,
  lib,
  ...
}: {
  nixpkgs.localSystem.system = "aarch64-linux";

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = ["noatime"];
    };
  };

  environment.systemPackages = with pkgs; [vim];

  # Enable GPU acceleration
  hardware.raspberry-pi."4".fkms-3d.enable = true;

  boot = {
    # Use mainline kernel, vendor kernel has some issues compiling due to
    # missing modules that shouldn't even be in the closure.
    # https://github.com/NixOS/nixpkgs/issues/111683
    #kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = lib.mkForce ["bridge" "macvlan" "tap" "tun" "loop" "atkbd" "ctr"];
    supportedFilesystems = lib.mkForce ["btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs" "ext4" "vfat"];
  };

  # this will be disabled once I have SSH keys set up and working *properly*
  services = {
    xserver = {
      enable = true;
      displayManager.lightdm.enable = true;
      desktopManager.xfce.enable = true;
    };

    create_ap = {
      enable = false;
      settings = {
        INTERNET_IFACE = "eth0";
        WIFI_IFACE = "wlan0";
        SSID = "Pizone";
        PASSPHRASE = "12345678";
      };
    };
  };
}
