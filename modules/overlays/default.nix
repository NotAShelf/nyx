final: prev: {
  nixos-plymouth = prev.callPackage ./plymouth {};
  fastfetch = prev.callPackage ./fastfetch {};

  catppuccin-gtk = prev.callPackage ../../pkgs/catppuccin-gtk.nix {};
  catppuccin-folders = prev.callPackage ../../pkgs/catppuccin-folders.nix {};
  catppuccin-cursors = prev.callPackage ../../pkgs/catppuccin-cursors.nix {};

  cloneit = prev.callPackage ../../pkgs/cloneit.nix {};
  proton-ge = prev.callPackage ../../pkgs/proton-ge.nix {};
  anime4k = prev.callPackage ../../pkgs/anime4k.nix {};

  ungoogled-chromium = prev.ungoogled-chromium.override {
    commandLineArgs = toString [
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
    ];
  };
}
