{lib, ...}: let
  inherit (lib.options) mkEnableOption;
in {
  options.modules.usrEnv.services.media = {
    mpd.enable = mkEnableOption "mpd service";
  };
}
