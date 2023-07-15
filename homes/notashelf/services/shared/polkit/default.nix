{
  lib,
  osConfig,
  pkgs,
  ...
}:
with lib; let
  device = osConfig.modules.device;
  video = osConfig.modules.system.video;
  env = osConfig.modules.usrEnv;

  acceptedTypes = ["desktop" "laptop" "lite" "hybrid"];
in {
  config = mkIf ((builtins.elem device.type acceptedTypes) && (video.enable)) {
    # gnome polkit agent
    systemd.user.services.polkit-pantheon-authentication-agent-1 = lib.mkGraphicalService {
      #Service.ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Service.ExecStart = "${pkgs.pantheon.pantheon-agent-polkit}/libexec/policykit-1-pantheon/io.elementary.desktop.agent-polkit";
    };
  };
}
