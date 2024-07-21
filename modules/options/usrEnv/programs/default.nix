{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.types) attrs attrsOf bool str enum listOf package;

  inherit (config) modules;
  prg = modules.usrEnv.programs;

  json = pkgs.formats.json {};
in {
  imports = [
    ./gaming.nix
    ./launchers.nix
    ./lockers.nix
    ./media.nix
  ];

  options.modules.usrEnv.programs = {
    spotify.enable = mkEnableOption "Spotify music player";
    thunderbird.enable = mkEnableOption "Thunderbird mail client";
    vscode.enable = mkEnableOption "Visual Studio Code";
    steam.enable = mkEnableOption "Steam game client";
    kdeconnect.enable = mkEnableOption "KDE Connect utility";
    webcord.enable = mkEnableOption "Webcord Discord client";
    zathura.enable = mkEnableOption "Zathura document viewer";
    nextcloud.enable = mkEnableOption "Nextcloud cloud storage client";
    rnnoise.enable = mkEnableOption "RNNoise noise suppression plugin";
    noisetorch.enable = mkEnableOption "NoiseTorch noise suppression plugin";
    dolphin.enable = mkEnableOption "Dolphin file manager";

    libreoffice = {
      enable = mkEnableOption "LibreOffice suite";
      package = mkOption {
        type = package;
        default = pkgs.libreoffice-qt;
        description = "The package to use for LibreOffice";
      };

      extraPackages = mkOption {
        type = listOf package;
        default = with pkgs; [
          hyphen # text hyphenation library
          hunspell # spell checker
          hunspellDicts.en_US-large
          hunspellDicts.en_GB-large
        ];

        description = ''
          Additional packages to wrap Libreoffice with.
        '';
      };

      wrappedPackage = mkOption {
        readOnly = true;
        internal = true;
        type = package;
        default = pkgs.symlinkJoin {
          name = "Libreoffice";
          paths = [prg.libreoffice.package prg.libreoffice.extraPackages];
        };

        description = ''
          The LibreOffice package with additional wrapper features.
        '';
      };
    };

    obs = {
      enable = mkEnableOption "OBS Studio";
      package = mkOption {
        type = package;
        default = pkgs.obs-studio;
        description = "The package to use for OBS Studio";
      };

      plugins = mkOption {
        type = listOf package;
        default = [
          pkgs.obs-gstreamer
          pkgs.obs-pipewire-audio-capture
          pkgs.obs-vkcapture
        ];

        description = ''
          A list of plugins to enable in OBS Studio.
        '';
      };
    };

    discord = {
      enable = mkEnableOption "Discord messenger";
      package = mkOption {
        type = package;
        default = pkgs.discord;
        description = "The package to use for Discord";
      };

      wrappedPackage = mkOption {
        readOnly = true;
        internal = true;
        type = package;
        default = prg.discord.package.override {
          nss = pkgs.nss_latest;
          withOpenASAR = true;
          withVencord = true;
        };

        description = ''
          The Discord package with additional wrapper features.

          For good measure, this shall include OpenASAR and
          Vencord to aid with performance and customizability
          respectively.
        '';
      };
    };

    element = {
      enable = mkEnableOption "Element Matrix client";
      package = mkOption {
        type = package;
        default = pkgs.element-desktop;
        description = "The package to use for Element";
      };

      settings = mkOption {
        type = attrsOf json.type;
        default = {
          default_theme = "dark";
          show_labs_settings = true;
          default_server_config = {
            "m.homeserver" = {
              base_url = "https://notashelf.dev";
              server_name = "notashelf.dev";
            };

            "m.identity_server".base_url = "";
          };
        };
      };
    };

    chromium = {
      enable = mkEnableOption "Chromium browser";
      ungoogle = mkOption {
        type = bool;
        default = true;
        description = "Whether to enable ungoogled-chromium features";
      };

      enabledFeatures = mkOption {
        type = listOf str;
        default = [
          "BackForwardCache:enable_same_site/true"
          "CopyLinkToText"
          "OverlayScrollbar"
          "TabHoverCardImages"
          "VaapiVideoDecoder"
        ];

        description = ''
          A list of features to enable in Chromium. For a list of available
          features, see: https://chromium.googlesource.com/chromium/src/+/HEAD/chrome/common/chrome_features.cc
        '';
      };
    };

    firefox = {
      enable = mkEnableOption "Firefox browser";
      schizofox.enable = mkOption {
        type = bool;
        default = true;
        description = ''
          Whether to replace default Firefox package with Schizofox, a
          privacy friendly Firefox configuration wrapper.
        '';
      };
    };

    librewolf = {
      enable = mkEnableOption "LibreWolf browser";
      package = mkOption {
        type = package;
        default = pkgs.librewolf;
        description = "The package to use for LibreWolf";
      };

      wrappedPackage = mkOption {
        readOnly = true;
        internal = true;
        type = package;
        default = prg.librewolf.package.override {cfg.speechSynthesisSupport = false;};
        description = ''
          The LibreWolf package with additional wrapper features.
        '';
      };

      extraConfig = mkOption {
        type = attrs;
        default = {};
        description = ''
          Additional configuration options that will be passed
          to the Librwolf wrapper.
        '';
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
        type = str;
        default = "";
        description = "The default gpg key used for signing commits";
      };
    };

    default = {
      terminal = mkOption {
        type = enum ["foot" "kitty" "wezterm"];
        default = "kitty";
      };

      fileManager = mkOption {
        type = enum ["thunar" "dolphin" "nemo"];
        default = "dolphin";
      };

      browser = mkOption {
        type = enum ["firefox" "librewolf" "chromium"];
        default = "firefox";
      };

      editor = mkOption {
        type = enum ["neovim" "helix" "emacs"];
        default = "neovim";
      };

      launcher = mkOption {
        type = enum ["rofi" "wofi" "anyrun"];
        default = "rofi";
      };
    };
  };
}
