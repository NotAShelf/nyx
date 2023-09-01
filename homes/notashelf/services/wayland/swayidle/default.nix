{
  lib,
  pkgs,
  config,
  osConfig,
  ...
}:
with lib; let
  locker = lib.getExe pkgs."${env.screenLock}";

  systemctl = "${pkgs.systemd}/bin/systemctl";
  suspendScript = pkgs.writeShellScript "suspend-script" ''
    ${pkgs.pipewire}/bin/pw-cli i all | ${pkgs.ripgrep}/bin/rg running
    # only suspend if audio isn't running
    if [ $? == 1 ]; then
      ${systemctl} suspend
    fi
  '';
  env = osConfig.modules.usrEnv;

  acceptedTypes = ["desktop" "laptop" "lite" "hybrid"];
in {
  config = mkIf ((lib.isAcceptedDevice osConfig acceptedTypes) && (lib.isWayland osConfig)) {
    # start swayidle as part of hyprland instead of sway
    systemd.user.services.swayidle.Install.WantedBy = lib.mkForce ["hyprland-session.target"];

    # screen idle
    services.swayidle = {
      enable = true;
      extraArgs = ["-d" "-w"];
      events = [
        {
          event = "before-sleep";
          command = "${pkgs.systemd}/bin/loginctl lock-session";
        }
        {
          event = "lock";
          command = "${locker}";
        }
      ];
      timeouts = [
        {
          timeout = 900;
          command = suspendScript.outPath;
        }
        {
          timeout = 1200;
          command = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl dispatch dpms off";
          resumeCommand = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl dispatch dpms on";
        }
      ];
    };
  };
}
