{
  osConfig,
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (osConfig) modules;

  env = modules.usrEnv;
  srv = env.services;
in {
  config = mkIf srv.media.mpd.enable {
    home.packages = with pkgs; [
      playerctl # CLI interface for playerctld
      mpc_cli # CLI interface for mpd
      cava # CLI music visualizer (cavalier is a gui alternative)
    ];

    services = {
      playerctld.enable = true;
      mpris-proxy.enable = true;
      mpd-mpris.enable = true;

      # music player daemon service
      mpd = {
        enable = true;
        musicDirectory = "${config.home.homeDirectory}/Media/Music";
        network = {
          startWhenNeeded = true;
          listenAddress = "127.0.0.1";
          port = 6600;
        };

        extraConfig = ''
          auto_update           "yes"
          volume_normalization  "yes"
          restore_paused        "yes"
          filesystem_charset    "UTF-8"

          audio_output {
            type                "pipewire"
            name                "PipeWire"
          }

          audio_output {
            type                "fifo"
            name                "Visualiser"
            path                "/tmp/mpd.fifo"
            format              "44100:16:2"
          }

          audio_output {
           type		              "httpd"
           name		              "lossless"
           encoder		          "flac"
           port		              "8000"
           max_clients	        "8"
           mixer_type	          "software"
           format		            "44100:16:2"
          }
        '';
      };

      # MPRIS 2 support to mpd
      mpdris2 = {
        enable = true;
        notifications = true;
        multimediaKeys = true;
        mpd = {
          # for some reason config.xdg.userDirs.music is not a "path" - possibly because it has $HOME in its name?
          inherit (config.services.mpd) musicDirectory;
        };
      };

      # discord rich presence for mpd
      mpd-discord-rpc = {
        enable = true;
        settings = {
          format = {
            details = "$title";
            state = "On $album by $artist";
            large_text = "$album";
            small_image = "";
          };
        };
      };
    };

    programs = {
      /*
      # yams service
      # TODO: figure out a way to provide the lastfm authentication declaratively

      systemd.user.services.yams = {
        Unit = {
          Description = "Last.FM scrobbler for MPD";
          After = ["mpd.service"];
        };
        Service = {
          ExecStart = "${pkgs.yams}/bin/yams -N";
          Environment = "NON_INTERACTIVE=1";
          Restart = "always";
        };
        Install.WantedBy = ["default.target"];
      };
      */
    };
  };
}
