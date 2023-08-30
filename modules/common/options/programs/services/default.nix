{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types;
in {
  # this module provides a set of options for commonly used programs
  # and leaves it to the host to enable or disable them
  options.modules = {
    programs = {
      libreoffice.enable = mkEnableOption "Enable Libreoffice suite";
      chromium.enable = mkEnableOption "Enable Chromium browser";
      thunderbird.enable = mkEnableOption "Enable Thunderbird mail client";
      vscode.enable = mkEnableOption "Enable Visual Studio Code";
      obs.enable = mkEnableOption "Enable OBS Studio";
      spotify.enable = mkEnableOption "Enable Spotify";
      zathura.enable = mkEnableOption "Enable Zathura document viewer";
      steam.enable = mkEnableOption "Enable Steam";
      mangohud.enable = mkEnableOption "Enable MangoHud" // {default = config.modules.programs.steam.enable;};

      firefox = {
        enable = mkEnableOption "Enable Firefox";
        client = mkOption {
          # schizofox is a heavy patched version of Firefox with a lot of privacy features
          # https://github.com/schizofox/schizofox
          type = types.enum ["default" "schizofox"];
          default = "schizofox"; # never take your meds
          description = "The Firefox module to be used";
        };
      };

      discord = {
        enable = mkEnableOption "Enable Discord messenger";
        client = mkOption {
          type = types.enum ["stable" "canary" "webcord"];
          default = "webcord";
          description = "The Discord client to be used";
        };
      };
    };
  };
}
