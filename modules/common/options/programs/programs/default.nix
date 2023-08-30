{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types;
in {
  imports = [
    ./defaults
    ./git.nix
  ];
  options.modules = {
    programs = {
      # package bundles
      cli.enable = mkEnableOption "Enable a bundle of CLI packages";
      gui.enable = mkEnableOption "Enable a bundle GUI programs";

      # per-program enable options
      libreoffice.enable = mkEnableOption "Enable Libreoffice suite";
      chromium.enable = mkEnableOption "Enable Chromium browser";
      thunderbird.enable = mkEnableOption "Enable Thunderbird mail client";
      vscode.enable = mkEnableOption "Enable Visual Studio Code";
      obs.enable = mkEnableOption "Enable OBS Studio";
      spotify.enable = mkEnableOption "Enable Spotify";
      zathura.enable = mkEnableOption "Enable Zathura document viewer";

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

      gaming = {
        enable = mkEnableOption "Enable packages required for the device to be gaming-ready";
        emulation.enable = mkEnableOption "Enable programs required to emulate other platforms";
        chess.enable = mkEnableOption "Chess programs and engines";

        # gaming clients and utilities
        steam.enable = mkEnableOption "Enable Steam" // {default = config.modules.programs.gaming.enable;};
        gamescope.enable = mkEnableOption "Gamescope compositing manager" // {default = config.modules.programs.gaming.enable;};
        mangohud.enable = mkEnableOption "Enable MangoHud" // {default = config.modules.programs.gaming.enable;};
        #lutris.enable = mkEnableOption "Enable Lutris" // {default = config.modules.programs.gaming.enable;}; # TODO
      };
    };
  };
}
