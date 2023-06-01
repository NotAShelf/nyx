{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  sys = config.modules.system;
in {
  config = mkIf (sys.video.enable) {
    hardware = {
      opengl = {
        enable = true;
        driSupport = true;
        # TODO: enable this ONLY if system is 64bit
        driSupport32Bit = true;
      };
    };
    users.users.${sys.username}.extraGroups = ["video"];
  };
}
