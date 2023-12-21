{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkDefault;
  inherit (config.modules) device;
in {
  imports = [
    ./systemd.nix
    ./zram.nix
  ];

  services = {
    # monitor and control temparature
    thermald.enable = true;

    # discard blocks that are not in use by the filesystem, good for SSDs
    fstrim.enable = true;

    # firmware updater for machine hardware
    fwupd = {
      enable = true;
      daemonSettings.EspLocation = config.boot.loader.efi.efiSysMountPoint;
    };

    # I don't use lvm, can be disabled
    lvm.enable = mkDefault false;

    # enable smartd monitoring
    smartd.enable = true;
  };
}
