{
  inputs',
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types literalExpression;
in {
  options.modules.usrEnv.programs.media = {
    addDefaultPackages = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to enable the default list of media-related packages ranging from audio taggers
        to video editors.
      '';
    };

    extraPackages = mkOption {
      type = with types; listOf package;
      default = [];
      description = ''
        Additional packages that will be appended to media related packages.
      '';
    };

    ncmpcpp.enable = mkEnableOption "ncmpcpp TUI music player";

    beets.enable =
      mkEnableOption ''
        beets media library system.


        Will be enabled automatically if  {option}`config.modules.usrEnv.services.mpd.enabled`
        is set to true
      ''
      // {default = config.modules.usrEnv.services.media.mpd.enable;};

    mpv = {
      enable = mkEnableOption "mpv media player";
      scripts = mkOption {
        type = with types; listOf package;
        description = "A list of MPV scripts that will be enabled";
        example = literalExpression ''[ pkgs.mpvScripts.cutter ]'';
        default = with pkgs.mpvScripts; [
          # from nixpkgs
          cutter # cut and automatically concat videos
          mpris # MPRIS plugin
          thumbnail # OSC seekbar thumbnails
          thumbfast # on-the-fly thumbnailer
          sponsorblock # skip sponsored segments
          uosc # proximity UI
          quality-menu # ytdl-format quality menu
          seekTo # seek to spefici pos.

          # from nyxpkgs
          inputs'.nyxpkgs.packages.mpv-history # save a history of played files with timestamps
        ];
      };
    };
  };
}
