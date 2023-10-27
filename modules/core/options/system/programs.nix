{lib, ...}: let
  inherit (lib) mkEnableOption mkOption types;
in {
  options.modules = {
    programs = {
      libreoffice.enable = mkEnableOption "LibreOffice suite";
      discord.enable = mkEnableOption "Discord messenger";
      chromium.enable = mkEnableOption "Chromium browser";
      obs.enable = mkEnableOption "OBS Studio";
      spotify.enable = mkEnableOption "Spotify music player";
      thunderbird.enable = mkEnableOption "Thunderbird mail client";
      vscode.enable = mkEnableOption "Visual Studio Code";
      zathura.enable = mkEnableOption "Zathura document viewer";

      firefox = {
        enable = mkEnableOption "Firefox browser";
        schizofox = mkOption {
          type = types.bool;
          default = true;
          description = "Enable Schizofox Firefox Tweaks";
        };
      };
    };
  };
}
