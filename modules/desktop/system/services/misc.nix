{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  device = config.modules.device;
  acceptedTypes = ["desktop" "laptop" "hybrid" "lite"];
in {
  config = mkIf (builtins.elem device.type acceptedTypes) {
    services = {
      # enable GVfs, a userspace virtual filesystem.
      gvfs.enable = true;

      # thumbnail support on thunar
      tumbler.enable = true;

      # storage daemon required for udiskie auto-mount
      udisks2.enable = true;

      dbus = {
        packages = with pkgs; [dconf gcr udisks2];
        enable = true;
      };
    };

    systemd = let
      extraConfig = ''
        DefaultTimeoutStopSec=15s
      '';
    in {
      inherit extraConfig;
      user = {inherit extraConfig;};
      services."getty@tty1".enable = false;
      services."autovt@tty1".enable = false;
      services."getty@tty7".enable = false;
      services."autovt@tty7".enable = false;

      # TODO channels-to-flakes
      tmpfiles.rules = [
        "D /nix/var/nix/profiles/per-user/root 755 root root - -"
      ];
    };
  };
}
