{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types;
in {
  options.modules = {
    programs = {
      gui.enable = mkEnableOption "GUI package sets" // {default = true;};
      cli.enable = mkEnableOption "CLI package sets" // {default = true;};
      dev.enable = mkEnableOption "development related package sets";

      libreoffice.enable = mkEnableOption "LibreOffice suite";
      discord.enable = mkEnableOption "Discord messenger";
      obs.enable = mkEnableOption "OBS Studio";
      spotify.enable = mkEnableOption "Spotify music player";
      thunderbird.enable = mkEnableOption "Thunderbird mail client";
      vscode.enable = mkEnableOption "Visual Studio Code";
      zathura.enable = mkEnableOption "Zathura document viewer";
      steam.enable = mkEnableOption "Steam game client";

      chromium = {
        enable = mkEnableOption "Chromium browser";
        ungoogle = mkOption {
          type = types.bool;
          default = true;
          description = "Enable ungoogled-chromium features";
        };
      };

      firefox = {
        enable = mkEnableOption "Firefox browser";
        schizofox = mkOption {
          type = types.bool;
          default = true;
          description = "Enable Schizofox Firefox Tweaks";
        };
      };

      editors = {
        neovim.enable = mkEnableOption "Neovim text editor";
        helix.enable = mkEnableOption "Helix text editor";
      };

      terminals = {
        kitty.enable = mkEnableOption "Kitty terminal emulator";
        wezterm.enable = mkEnableOption "WezTerm terminal emulator";
        foot.enable = mkEnableOption "Foot terminal emulator";
      };

      gaming = {
        enable = mkEnableOption "Enable packages required for the device to be gaming-ready";
        emulation.enable = mkEnableOption "Enable programs required to emulate other platforms";
        chess.enable = mkEnableOption "Chess programs and engines" // {default = config.modules.programs.gaming.enable;};
        gamescope.enable = mkEnableOption "Gamescope compositing manager" // {default = config.modules.programs.gaming.enable;};
      };

      media = {
        mpv.enable = mkEnableOption "mpv media player";
        addDefaultPackages = mkOption {
          type = types.bool;
          default = true;
          description = "Add default mpv packages";
        };

        extraDefaultPackages = mkOption {
          type = with types; listOf package;
          default = [];
          description = "Add extra mpv packages";
        };
      };

      git = {
        signingKey = mkOption {
          type = types.str;
          default = "";
          description = "The default gpg key used for signing commits";
        };
      };

      # default program options
      default = {
        # what program should be used as the default terminal
        terminal = mkOption {
          type = types.enum ["foot" "kitty" "wezterm"];
          default = "kitty";
        };

        fileManager = mkOption {
          type = types.enum ["thunar" "dolphin" "nemo"];
          default = "dolphin";
        };

        browser = mkOption {
          type = types.enum ["firefox" "librewolf" "chromium"];
          default = "firefox";
        };

        editor = mkOption {
          type = types.enum ["neovim" "helix" "emacs"];
          default = "neovim";
        };

        launcher = mkOption {
          type = types.enum ["rofi" "wofi" "anyrun"];
          default = "rofi";
        };
      };
    };
  };
}
