{
  lib,
  pkgs,
  osConfig,
  ...
}: let
  inherit (lib) mkIf optionals concatStringsSep;
  inherit (osConfig) modules;

  env = modules.usrEnv;
  sys = modules.system;
  prg = sys.programs;
in {
  config = mkIf prg.chromium.enable {
    programs.chromium = {
      enable = true;
      extensions = [
        {id = "mnjggcdmjocbbbhaepdhchncahnbgone";} # sponsor block
        {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";} # ublock
        {id = "nngceckbapebfimnlniiiahkandclblb";} # bitwarden
        {id = "iaiomicjabeggjcfkbimgmglanimpnae";} # tab manager
      ];

      package = pkgs.ungoogled-chromium.override {
        nss = pkgs.nss_latest;
        commandLineArgs =
          [
            # Ungoogled features
            "--disable-search-engine-collection"
            "--extension-mime-request-handling=always-prompt-for-install"
            "--fingerprinting-canvas-image-data-noise"
            "--fingerprinting-canvas-measuretext-noise"
            "--fingerprinting-client-rects-noise"
            "--popups-to-tabs"
            "--show-avatar-button=incognito-and-guest"

            # Experimental features
            "--enable-features=${
              concatStringsSep "," [
                "BackForwardCache:enable_same_site/true"
                "CopyLinkToText"
                "OverlayScrollbar"
                "TabHoverCardImages"
                "VaapiVideoDecoder"
              ]
            }"

            # Aesthetics
            "--force-dark-mode"

            # Performance
            "--enable-gpu-rasterization"
            "--enable-oop-rasterization"
            "--enable-zero-copy"
            "--ignore-gpu-blocklist"

            # Etc
            # "--gtk-version=4"
            "--disk-cache=$XDG_RUNTIME_DIR/chromium-cache"
            "--no-default-browser-check"
            "--no-service-autorun"
            "--disable-features=PreloadMediaEngagementData,MediaEngagementBypassAutoplayPolicies"
            "--disable-reading-from-canvas"
            "--no-pings"
            "--no-first-run"
            "--no-experiments"
            "--no-crash-upload"
            "--disable-wake-on-wifi"
            "--disable-breakpad"
            "--disable-sync"
            "--disable-speech-api"
            "--disable-speech-synthesis-api"
          ]
          ++ optionals env.isWayland [
            # Wayland

            # Disabled because hardware acceleration doesn't work
            # when disabling --use-gl=egl, it's not gonna show any emoji
            # and it's gonna be slow as hell
            # "--use-gl=egl"

            "--ozone-platform=wayland"
            "--enable-features=UseOzonePlatform"
          ];
      };
    };
  };
}
