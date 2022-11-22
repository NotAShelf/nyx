{
  config,
  pkgs,
  lib,
  ...
}: {
  #nixpkgs.localSystem.system = "aarch64-linux";

  #fileSystems = {
  #  "/" = {
  #    device = "/dev/disk/by-label/NIXOS_SD";
  #    fsType = "ext4";
  #    options = ["noatime"];
  #  };
  #};

  environment.systemPackages = with pkgs; [git neovim];

  # Enable GPU acceleration
  hardware.raspberry-pi."4".fkms-3d.enable = true;

  boot = {
    # Use mainline kernel, vendor kernel has some issues compiling due to
    # missing modules that shouldn't even be in the closure.
    # https://github.com/NixOS/nixpkgs/issues/111683
    
    # we define this at config level so that we can use it in the
    # pi module
    #kernelPackages = pkgs.linuxPackages_latest;
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
    abrmd.enable = false;
  };
}
