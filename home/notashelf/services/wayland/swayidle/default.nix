{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:
with lib; let
  suspendScript = pkgs.writeShellScript "suspend-script" ''
    ${pkgs.pipewire}/bin/pw-cli i all | ${pkgs.ripgrep}/bin/rg running
    # only suspend if audio isn't running
    if [ $? == 1 ]; then
      ${pkgs.systemd}/bin/systemctl suspend
    fi
  '';
  device = osConfig.modules.device;
  env = osConfig.modules.usrEnv;

  acceptedTypes = ["desktop" "laptop" "lite" "hybrid"];
in {
  config = mkIf (builtins.elem device.type acceptedTypes && env.isWayland) {
    # screen idle
    services.swayidle = {
      enable = true;
      events = [
        {
          event = "before-sleep";
          command = "${pkgs.swaylock-effects}/bin/swaylock -fF";
        }
        {
          event = "lock";
          command = "${pkgs.swaylock-effects}/bin/swaylock -fF";
        }
      ];
      timeouts = [
        {
          timeout = 310;
          command = "${pkgs.systemd}/bin/loginctl lock-session";
        }
        {
          timeout = 310;
          command = suspendScript.outPath;
        }
      ];
    };
  };
}
