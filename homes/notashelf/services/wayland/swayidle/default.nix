{
  osConfig,
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) getExe mkIf;

  env = osConfig.modules.usrEnv;
  locker = getExe env.programs.screenlock.package;

  systemctl = "${pkgs.systemd}/bin/systemctl";
  suspendScript = pkgs.writeShellScript "suspend-script" ''
    ${pkgs.pipewire}/bin/pw-cli i all | ${pkgs.ripgrep}/bin/rg running
    # only suspend if audio isn't running
    if [ $? == 1 ]; then
      ${systemctl} suspend
    fi
  '';
in {
  # TODO: can we make it so that it works with sway *or* hyprland based on which one is enabled?
  config = mkIf env.desktops.hyprland.enable {
    systemd.user.services.swayidle.Install.WantedBy = ["hyprland-session.target"];

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
