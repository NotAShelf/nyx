{lib, ...}: let
  inherit (lib) mkEnableOption mkOption types;
in {
  imports = [
    ./gaming.nix
    ./media.nix
  ];

  options.modules.system.programs = {
    gui.enable = mkEnableOption "GUI package sets" // {default = true;};
    cli.enable = mkEnableOption "CLI package sets" // {default = true;};
    dev.enable = mkEnableOption "development related package sets";

    libreoffice.enable = mkEnableOption "LibreOffice suite";
    discord.enable = mkEnableOption "Discord messenger";
    element.enable = mkEnableOption "Element Matrix client";
    obs.enable = mkEnableOption "OBS Studio";
    spotify.enable = mkEnableOption "Spotify music player";
    thunderbird.enable = mkEnableOption "Thunderbird mail client";
    vscode.enable = mkEnableOption "Visual Studio Code";
    steam.enable = mkEnableOption "Steam game client";
    kdeconnect.enable = mkEnableOption "KDE Connect utility";
    webcord.enable = mkEnableOption "Webcord Discord client";
    zathura.enable = mkEnableOption "Zathura document viewer";
    nextcloud.enable = mkEnableOption "Nextcloud sync client";
    rnnoise.enable = mkEnableOption "RNNoise noise suppression plugin";
    noisetorch.enable = mkEnableOption "NoiseTorch noise suppression plugin";

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
      schizofox.enable = mkOption {
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
}
