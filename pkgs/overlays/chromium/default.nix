{
  prev,
  final,
  config,
  lib,
  ...
}:
with lib; let
  env = config.modules.usrEnv;
in {
  ungoogled-chromium = prev.ungoogled-chromium.override {
    commandLineArgs =
      toString [
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
          final.lib.concatStringsSep "," [
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
      ]
      ++ optionals (env.isWayland) [
        "--enable-features=UseOzonePlatform"
        "--ozone-platform=wayland"
      ];
  };
}
