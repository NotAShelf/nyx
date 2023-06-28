{
  inputs,
  pkgs,
  osConfig,
  lib,
  ...
}: let
  device = osConfig.modules.device;
  env = osConfig.modules.usrEnv;
  sys = osConfig.modules.system;
  acceptedTypes = ["laptop" "desktop" "hybrid" "lite"];
in {
  imports = [inputs.anyrun.homeManagerModules.default];
  config = lib.mkIf (builtins.elem device.type acceptedTypes && (sys.video.enable && env.isWayland)) {
    # home.packages = [anyrun];

    programs.anyrun = {
      enable = true;
      config = {
        plugins = with inputs.anyrun.packages.${pkgs.system}; [
          applications
          rink
          translate
          randr
          shell
          symbols
          translate
        ];

        # Where Anyrun is located on the screen: Top, Center
        position = "top";

        # How much the runner is shifted vertically
        verticalOffset.absolute = 15;

        # Hide match and plugin info icons
        hideIcons = false;

        # ignore exclusive zones, i.e. Waybar
        ignoreExclusiveZones = false;

        # Layer shell layer: Background, Bottom, Top, Overlay
        layer = "overlay";

        # Hide the plugin info panel
        hidePluginInfo = false;

        # Close window when a click outside the main box is received
        closeOnClick = false;

        # Show search results immediately when Anyrun starts
        showResultsImmediately = false;

        # Limit amount of entries shown in total
        maxEntries = null;
      };

      extraCss = ''
        * {
          transition: 200ms ease;
          font-family: Lexend;
          font-size: 1.3rem;
        }

        #window,
        #match,
        #entry,
        #plugin,
        #main {
          background: transparent;
        }

        #match:selected {
          background: rgba(203, 166, 247, 0.7);
        }

        #match {
          padding: 3px;
          border-radius: 16px;
        }

        #entry, #plugin:hover {
          border-radius: 16px;
        }

        box#main {
          background: rgba(30, 30, 46, 0.7);
          border: 1px solid #28283d;
          border-radius: 24px;
          padding: 8px;
        }
      '';
    };
  };
}
