{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf mkDefault;
in {
  security.polkit = {
    enable = true;

    # optionally, log all actions that can be recorded by polkit
    # if polkit debugging has been enabled
    debug = mkDefault true;
    extraConfig = mkIf config.security.polkit.debug ''
      /* Log authorization checks. */
      polkit.addRule(function(action, subject) {
        polkit.log("user " +  subject.user + " is attempting action " + action.id + " from PID " + subject.pid);
      });
    '';
  };
}
