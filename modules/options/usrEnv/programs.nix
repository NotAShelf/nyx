{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types;
  cfg = config.modules.usrEnv.programs;
in {
  options.modules.usrEnv.programs = {
    # package bundles
    cli = {
      enable = mkEnableOption "Enable a bundle of CLI packages";
      whitehat.enable = mkEnableOption "Enable tools for pentesting";
    };

    gui.enable = mkEnableOption "Enable a bundle GUI programs";

    # per-program enable options
    libreoffice.enable = mkEnableOption "Enable Libreoffice suite";
    chromium.enable = mkEnableOption "Enable Chromium browser";
    thunderbird.enable = mkEnableOption "Enable Thunderbird mail client";
    vscode.enable = mkEnableOption "Enable Visual Studio Code";
    obs.enable = mkEnableOption "Enable OBS Studio";
    spotify.enable = mkEnableOption "Enable Spotify";
    zathura.enable = mkEnableOption "Enable Zathura document viewer";
    bat.enable = mkEnableOption "Enable bat";
    bottom.enable = mkEnableOption "Enable bottom";
    newsboat.enable = mkEnableOption "Enable Newsboat";
    ranger.enable = mkEnableOption "Enable Ranger";
    xplr.enable = mkEnableOption "Enable Xplr";

    firefox = {
      enable = mkEnableOption "Enable Firefox";
      client = mkOption {
        # schizofox is a heavy patched version of Firefox with a lot of privacy features
        # https://github.com/schizofox/schizofox
        type = types.enum ["default" "schizofox"];
        default = "schizofox"; # never take your meds
        description = "The Firefox module to be used";
      };
    };

    discord = {
      enable = mkEnableOption "Enable Discord messenger";
      client = mkOption {
        type = types.enum ["stable" "canary" "webcord"];
        default = "webcord";
        description = "The Discord client to be used";
      };
    };

    git = {
      signingKey = mkOption {
        type = types.str;
        default = "";
        description = "The default gpg key used for signing commits";
      };
    };

    gaming = {
      enable = mkEnableOption "Enable packages required for the device to be gaming-ready";
      emulation.enable = mkEnableOption "Enable programs required to emulate other platforms";
      chess.enable = mkEnableOption "Enable chess programs and engines";
      minecraft.enable = mkEnableOption "Enable Minecraft";

      # gaming clients and utilities
      steam.enable = mkEnableOption "Enable Steam" // {default = cfg.gaming.enable;};
      gamescope.enable = mkEnableOption "Gamescope compositing manager" // {default = cfg.gaming.enable;};
      mangohud.enable = mkEnableOption "Enable MangoHud" // {default = cfg.gaming.enable;};
      lutris.enable = mkEnableOption "Enable Lutris" // {default = cfg.gaming.enable;}; # TODO
    };

    # default program options
    defaults = {
      # what program should be used as the default terminal
      # do note this is NOT the command, but just the name. i.e setting footclient will
      # not work because the program name will be references as "foot" in the rest of the config
      terminal = mkOption {
        type = types.enum ["foot" "kitty" "wezterm"];
        default = "kitty";
        description = lib.mdDoc ''
          The terminal emulator to be used by default.
        '';
      };

      fileManager = mkOption {
        type = types.enum ["thunar" "dolphin" "nemo"];
        default = "dolphin";
        description = lib.mdDoc ''
          The file manager to be used by default.
        '';
      };

      browser = mkOption {
        type = types.enum ["firefox" "librewolf" "chromium"];
        default = "firefox";
        description = lib.mdDoc ''
          The browser to be used by default.
        '';
      };

      editor = mkOption {
        type = types.enum ["neovim" "helix" "emacs"];
        default = "neovim";
        description = lib.mdDoc ''
          The editor to be used by default.
        '';
      };

      launcher = mkOption {
        type = types.enum ["rofi" "wofi" "anyrun"];
        default = "rofi";
        description = lib.mdDoc ''
          The launcher to be used by default.
        '';
      };

      screenlocker = mkOption {
        type = with types; nullOr (enum ["swaylock" "gtklock"]);
        default = "gtklock";
        description = lib.mdDoc ''
          The lockscreen module to be loaded by home-manager.
        '';
      };

      noiseSupressor = mkOption {
        type = with types; nullOr (enum ["rnnoise" "noisetorch"]);
        default = "rnnoise";
        description = lib.mdDoc ''
          The noise supressor to be used for desktop systems with sound enabled.
        '';
      };
    };
  };
}
