{lib, ...}: let
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
    };
  };
}
