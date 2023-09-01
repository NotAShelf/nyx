{
  pkgs,
  config,
  lib,
  osConfig,
  ...
}:
with lib; let
  pamixer = lib.getExe pkgs.pamixer;
  notify-send = pkgs.libnotify + "/bin/notify-send";
  volume = pkgs.writeShellScriptBin "volume" ''
    #!/bin/sh

    ${pamixer} "$@"
    volume="$(${pamixer} --get-volume-human)"

    if [ "$volume" = "muted" ]; then
        ${notify-send} -r 69 \
            -a "Volume" \
            "Muted" \
            -i ${./assets/volume-mute.svg} \
            -t 888 \
            -u low
    else
        ${notify-send} -r 69 \
            -a "Volume" "Currently at $volume" \
            -h int:value:"$volume" \
            -i ${./assets/volume.svg} \
            -t 888 \
            -u low
    fi
  '';

  microphone = pkgs.writeShellScriptBin "microphone" ''
    #!/bin/sh

    ${pamixer} --default-source "$@"
    mic="$(${pamixer} --default-source --get-volume-human)"

    if [ "$mic" = "muted" ]; then
        ${notify-send} -r 69 \
            -a "Microphone" \
            "Muted" \
            -i ${./assets/mic-mute.svg} \
            -t 888 \
            -u low
    else
      ${notify-send} -r 69 \
            -a "Microphone" "Currently at $mic" \
            -h int:value:"$mic" \
            -i ${./assets/mic.svg} \
            -t 888 \
            -u low
    fi
  '';

  brightness = let
    brightnessctl = lib.getExe pkgs.brightnessctl;
  in
    pkgs.writeShellScriptBin "brightness" ''
      #!/bin/sh

      ${brightnessctl} "$@"
      brightness=$(echo $(($(${brightnessctl} g) * 100 / $(${brightnessctl} m))))

      ${notify-send} -r 69 \
          -a "Brightness" "Currently at $brightness%" \
          -h int:value:"$brightness" \
          -i ${./assets/brightness.svg} \
          -t 888 \
          -u low
    '';

  acceptedTypes = ["desktop" "laptop" "lite" "hybrid"];
in {
  config = lib.mkIf (lib.isAcceptedDevice osConfig acceptedTypes) {
    home.packages = [
      volume
      microphone
      brightness
    ];
    services.dunst = {
      enable = true;
      package = pkgs.dunst.overrideAttrs (_: {
        src = pkgs.fetchFromGitHub {
          owner = "sioodmy";
          repo = "dunst";
          rev = "6477864bd870dc74f9cf76bb539ef89051554525";
          sha256 = "FCoGrYipNOZRvee6Ks5PQB5y2IvN+ptCAfNuLXcD8Sc=";
        };
      });
      iconTheme = {
        package = config.gtk.iconTheme.package;
        name = "Papirus-Dark";
      };

      settings = let
        inherit (config.colorscheme) colors;
      in {
        global = {
          follow = "mouse";
          width = 320;
          height = 280;
          origin = "top-center";
          alignment = "left";
          vertical_alignment = "center";
          ellipsize = "middle";
          offset = "17x17";
          padding = 15;
          horizontal_padding = 15;
          text_icon_padding = 15;
          icon_position = "left";
          min_icon_size = 48;
          max_icon_size = 64;
          progress_bar = true;
          progress_bar_height = 8;
          progress_bar_frame_width = 1;
          progress_bar_min_width = 150;
          progress_bar_max_width = 300;
          separator_height = 2;
          frame_width = 2;
          frame_color = "#${colors.base0E}";
          separator_color = "frame";
          corner_radius = 8;
          transparency = 0;
          gap_size = 8;
          line_height = 0;
          notification_limit = 3;
          idle_threshold = 120;
          history_length = 20;
          show_age_threshold = 60;
          markup = "full";
          font = "Iosevka 16";
          word_wrap = "yes";
          sort = "yes";
          shrink = "no";
          indicate_hidden = "yes";
          sticky_history = "yes";
          ignore_newline = "no";
          show_indicators = "no";
          stack_duplicates = true;
          always_run_script = true;
          hide_duplicate_count = false;
          ignore_dbusclose = false;
          force_xwayland = false;
          force_xinerama = false;
          mouse_left_click = "do_action";
          mouse_middle_click = "close_all";
          mouse_right_click = "close_current";
        };

        fullscreen_delay_everything = {fullscreen = "delay";};

        urgency_low = {
          timeout = 3;
          background = "#${colors.base02}";
          foreground = "#${colors.base05}";
          highlight = "#${colors.base0C}";
        };

        urgency_normal = {
          timeout = 7;
          background = "#${colors.base02}";
          foreground = "#${colors.base05}";
          highlight = "#${colors.base0C}";
        };

        urgency_critical = {
          timeout = 0;
          background = "#${colors.base02}";
          foreground = "#${colors.base05}";
          highlight = "#${colors.base08}";
        };
      };
    };
  };
}
