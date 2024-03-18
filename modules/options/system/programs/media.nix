{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types literalExpression;
in {
  options.modules.system.programs.media = {
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

    mpv = {
      enable = mkEnableOption "mpv media player";
      scripts = mkOption {
        type = with types; listOf package;
        description = "A list of MPV scripts that will be enabled";
        example = literalExpression ''[ pkgs.mpvScripts.cutter ]'';
        default = with pkgs.mpvScripts; [
          cutter
          mpris # MPRIS plugin
          thumbnail # OSC seekbar thumbnails
          thumbfast # on-the-fly thumbnailer
          sponsorblock # skip sponsored segments
          uosc # proximity UI
          quality-menu # ytdl-format quality menu
          seekTo # seek to spefici pos.
          (pkgs.writeTextDir "share/history.lua" ''
            local HISTFILE = (os.getenv('XDG_DATA_HOME') or os.getenv('HOME'))..'/mpv/history.log';

            mp.register_event('file-loaded', function()
                local title, fp;

                title = mp.get_property('media-title');
                title = (title == mp.get_property('filename') and "" or (' (%s)'):format(title));

                fp = io.open(HISTFILE, 'a+');
                fp:write(('[%s] %s%s\n'):format(os.date('%Y-%m-%d %X'), mp.get_property('path'), title));
                fp:close();
            end)
          '')
        ];
      };
    };
  };
}
