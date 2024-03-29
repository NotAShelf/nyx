{
  osConfig,
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (osConfig) modules;

  env = modules.usrEnv;
  prg = env.programs;
in {
  programs.beets = mkIf prg.media.beets.enable {
    enable = true;

    settings = {
      ui.color = true;
      directory = config.services.mpd.musicDirectory;
      library = "${config.services.mpd.musicDirectory}/musiclibrary.db";

      clutter = [
        "Thumbs.DB"
        ".DS_Store"
        ".directory"
      ];

      plugins = [
        # "acousticbrainz" # DEPRECATED
        "mpdupdate"
        "lyrics"
        "thumbnails"
        "fetchart"
        "embedart"
        "chroma"
        "fromfilename"
        "lastgenre"
        "absubmit"
        "duplicates"
        "edit"
        "mbcollection"
        "mbsync"
        "replaygain"
        "scrub"
      ];

      import = {
        move = true;
        timid = true;
        detail = true;
        bell = true;
        write = true;
      };

      mpd = {
        host = "localhost";
        port = 6600;
      };

      lyrics = {
        auto = true;
      };

      thumbnails.auto = true;
      fetchart.auto = true;

      embedart = {
        auto = true;
        remove_art_file = true;
      };

      acousticbrainz.auto = true;
      chroma.auto = true;
      replaygain.backend = "gstreamer";
    };
  };
}
