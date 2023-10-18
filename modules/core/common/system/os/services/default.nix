{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkDefault;
  inherit (config.modules) device;
in {
  imports = [./systemd.nix];

  # compress half of the ram to use as swap
  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  services = {
    # monitor and control temparature
    thermald.enable = true;
    # discard blocks that are not in use by the filesystem, good for SSDs
    fstrim.enable = true;
    # firmware updater for machine hardware
    fwupd.enable = true;
    # I don't use lvm, can be disabled
    lvm.enable = mkDefault false;
    # enable smartd monitoering
    smartd.enable = true;

    # limit systemd journal size
    journald.extraConfig = mkIf (device.type != "server") ''
      SystemMaxUse=100M
      RuntimeMaxUse=50M
      SystemMaxFileSize=50M
    '';
  };
}
