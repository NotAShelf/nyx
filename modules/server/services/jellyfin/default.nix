{lib, ...}:
with lib; let
  device = config.modules.device;
  cfg = config.modules.programs.override;
  acceptedTypes = ["server" "hybrid"];
in
  mkIf (builtins.elem device.type acceptedTypes) {
    services.jellyfin = {
      enable = true;
      group = "jellyfin";
      user = "jellyfin";
      openFirewall = true;
    };
  }
