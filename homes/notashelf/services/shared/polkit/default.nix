{
  lib,
  osConfig,
  pkgs,
  ...
}: let
  inherit (lib) mkIf isAcceptedDevice mkGraphicalService;
  inherit (osConfig.modules.system) video;
  acceptedTypes = ["desktop" "laptop" "lite" "hybrid"];
in {
  config = mkIf ((isAcceptedDevice osConfig acceptedTypes) && video.enable) {
    # pantheon polkit agent
    systemd.user.services.polkit-pantheon-authentication-agent-1 = mkGraphicalService {
      #Service.ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Service.ExecStart = "${pkgs.pantheon.pantheon-agent-polkit}/libexec/policykit-1-pantheon/io.elementary.desktop.agent-polkit";
    };
  };
}
