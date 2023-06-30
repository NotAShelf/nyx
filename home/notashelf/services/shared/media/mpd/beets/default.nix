{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}: let
  musicDir = "${config.home.homeDirectory}/Media/Music";
  device = osConfig.modules.device;

  acceptedTypes = ["desktop" "laptop" "lite" "hybrid"];
in {
  config = lib.mkIf (builtins.elem device.type acceptedTypes) {
    programs = {
      beets = {
        enable = true;
        package = pkgs.beets;
        settings = {
          ui.color = true;
          directory = musicDir;
          library = "${musicDir}/musiclibrary.db";
          clutter = [
            "Thumbs.DB"
            ".DS_Store"
            ".directory"
          ];

          plugins = [
            "mpdupdate"
            "lyrics"
            "thumbnails"
            "fetchart"
            "embedart"
            # "acousticbrainz" # DEPRECATED
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
    };
  };
}
