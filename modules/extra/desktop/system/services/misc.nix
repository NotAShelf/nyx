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
        enable = true;
        packages = with pkgs; [dconf gcr udisks2];
        # Use the faster dbus-broker instead of the classic dbus-daemon
        implementation = "broker"; # TODO: keep an eye on this setting to see if it breaks anything
      };

      # disable chrony in favor if systemd-timesyncd
      timesyncd.enable = lib.mkDefault true;
      chrony.enable = lib.mkDefault false;
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
