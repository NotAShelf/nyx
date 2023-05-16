{
  lib,
  pkgs,
  inputs,
  osConfig,
  ...
}:
with lib; let
  device = osConfig.modules.device;
  env = osConfig.modules.usrEnv;
  acceptedTypes = ["desktop" "laptop" "hybrid"];
in {
  config = mkIf (builtins.elem device.type acceptedTypes) {
    programs.chromium = {
      enable = false;
      /*
      package = pkgs.chromium.override {
        commandLineArgs =
          lib.toString [
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
              lib.concatStringsSep "," [
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
      */

      extensions = [
        {id = "mnjggcdmjocbbbhaepdhchncahnbgone";} # sponsor block
        {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";} # ublock
        {id = "nngceckbapebfimnlniiiahkandclblb";} # bitwarden
        {id = "iaiomicjabeggjcfkbimgmglanimpnae";} # tab manager
      ];
    };
  };
}
