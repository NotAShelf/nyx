{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.system.video;
in {
  options.modules.system.video = {
    enable = mkEnableOption "video";
  };

  config = mkIf (cfg.enable) (mkMerge [
    {
      hardware = {
        opengl = {
          enable = true;
          driSupport = true;
          driSupport32Bit = true;
        };
      };
      users.users.${device.username}.extraGroups = ["video"];
    }
  ]);
}
