{
  lib,
  pkgs,
  config,
  osConfig,
  ...
}:
with lib; let
  swaylock = lib.getExe pkgs.swaylock-effects;

  systemctl = "${pkgs.systemd}/bin/systemctl";
  suspendScript = pkgs.writeShellScript "suspend-script" ''
    ${pkgs.pipewire}/bin/pw-cli i all | ${pkgs.ripgrep}/bin/rg running
    # only suspend if audio isn't running
    if [ $? == 1 ]; then
      ${systemctl} suspend
    fi
  '';
  device = osConfig.modules.device;
  env = osConfig.modules.usrEnv;

  acceptedTypes = ["desktop" "laptop" "lite" "hybrid"];
in {
  config = mkIf (builtins.elem device.type acceptedTypes && env.isWayland) {
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
          command = "${swaylock} -fF";
        }
      ];
      timeouts = [
        {
          timeout = 600;
          command = suspendScript.outPath;
        }
        {
          timeout = 900;
          command = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl dispatch dpms off";
          resumeCommand = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl dispatch dpms on";
        }
      ];
    };
  };
}
