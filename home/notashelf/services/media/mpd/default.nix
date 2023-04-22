{
  config,
  pkgs,
  osConfig,
  ...
}: let
  username = osConfig.modules.system.username;
in {
  # yams service
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

  services = {
    playerctld.enable = true;
    mpris-proxy.enable = true;
    mpd = {
      enable = true;
      musicDirectory = "/home/notashelf/Media/Music";
      network = {
        listenAddress = "any";
        port = 6600;
      };
      extraConfig = ''
        audio_output {
          type    "pipewire"
          name    "pipewire"
        }
        audio_output {
          type                    "fifo"
          name                    "fifo"
          path                    "/tmp/mpd.fifo"
          format                  "44100:16:2"
        }
        auto_update "yes"
      '';
    };

    mpd-discord-rpc = {
      enable = true;
      settings = {
        format = {
          details = "$title";
          state = "$artist";
          large_text = "$album";
          small_image = "";
        };
      };
    };

    mpdris2 = {
      enable = true;
      notifications = true;
      mpd = {
        host = "127.0.0.1";
      };
    };
  };

  home.packages = with pkgs; [
    playerctl # CLI interface for playerctld
    mpc_cli # control mpd through the CLI
    cava # music visualizer
    spek # spectogram analyzer
  ];

  programs.ncmpcpp = {
    enable = true;
    package = pkgs.ncmpcpp.override {
      visualizerSupport = true;
    };
    mpdMusicDir = "/home/${username}/Media/Music";
    settings = {
      # Miscelaneous
      ncmpcpp_directory = "${config.home.homeDirectory}/.config/ncmpcpp";
      ignore_leading_the = true;
      external_editor = "nvim";
      message_delay_time = 1;
      playlist_disable_highlight_delay = 2;
      autocenter_mode = "yes";
      centered_cursor = "yes";
      allow_for_physical_item_deletion = "no";
      lines_scrolled = "0";
      follow_now_playing_lyrics = "yes";
      lyrics_fetchers = "musixmatch";

      # visualizer
      visualizer_data_source = "/tmp/mpd.fifo";
      visualizer_output_name = "mpd_visualizer";
      visualizer_type = "ellipse";
      visualizer_look = "●● ";
      visualizer_color = "blue, green";

      # appearance
      colors_enabled = "yes";
      playlist_display_mode = "classic";
      user_interface = "classic";
      volume_color = "white";

      # window
      song_window_title_format = "Music";
      statusbar_visibility = "no";
      header_visibility = "no";
      titles_visibility = "no";
      # progress bar
      progressbar_look = "‎‎‎";
      progressbar_color = "black";
      progressbar_elapsed_color = "blue";

      # song list
      song_status_format = "$7%t";
      song_list_format = "$(008)%t$R  $(247)%a$R$5  %l$8";
      song_columns_list_format = "(53)[blue]{tr} (45)[blue]{a}";

      current_item_prefix = "$b$2| ";
      current_item_suffix = "$/b$5";

      now_playing_prefix = "$b$5| ";
      now_playing_suffix = "$/b$5";

      song_library_format = "{{%a - %t} (%b)}|{%f}";

      # colors
      main_window_color = "blue";

      current_item_inactive_column_prefix = "$b$5";
      current_item_inactive_column_suffix = "$/b$5";

      color1 = "white";
      color2 = "blue";
    };
    bindings = [
      {
        key = "j";
        command = "scroll_down";
      }
      {
        key = "k";
        command = "scroll_up";
      }
      {
        key = "J";
        command = ["select_item" "scroll_down"];
      }
      {
        key = "K";
        command = ["select_item" "scroll_up"];
      }
    ];
  };
}
