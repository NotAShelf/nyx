{
  config,
  lib,
  pkgs,
  ...
}:
with builtins; let
  cfg = config.programs.gtklock;

  inherit (lib) types mkIf mkOption mkEnableOption mkPackageOptionMD mdDoc literalExpression optionals;
  inherit (lib.generators) toINI;

  baseConfig = ''
    [main]
    gtk-theme=${cfg.config.gtk-theme or ""}
    style=${cfg.config.style or ""}
    modules=${concatStringsSep "," cfg.config.modules or ""}
  '';

  finalConfig = baseConfig + optionals (cfg.extraConfig != null) (toINI {} cfg.extraConfig);
in {
  meta.maintainers = [maintainers.NotAShelf];
  options.programs.gtklock = {
    enable = mkEnableOption "GTK-based lockscreen for Wayland" // {default = true;};
    package = mkPackageOptionMD pkgs "gtklock" {};

    config = {
      gtk-theme = mkOption {
        type = with types; nullOr str;
        default = null;
        description = mdDoc ''
          GTK theme to use for gtklock.
        '';
        example = "Adwaita-dark";
      };

      style = mkOption {
        type = with types; nullOr (oneOf [str path]);
        default = null;
        description = mdDoc ''
          The css file to be used for gtklock.
        '';
        example = literalExpression ''
          pkgs.writeText "gtklock-style.css" '''
            window {
              background-size: cover;
              background-repeat: no-repeat;
              background-position: center;
            }
          '''
        '';
      };

      modules = mkOption {
        type = with types; nullOr (listOf (either package str));
        default = null;
        description = mdDoc ''
          A list of gtklock modulesto use. Can either be packages, absolute paths, or strings.
        '';
        example = literalExpression ''
          ["${pkgs.gtklock-powerbar-module.outPath}/lib/gtklock/powerbar-module.so"];
        '';
      };
    };

    extraConfig = mkOption {
      type = with types; nullOr attrs;
      default = {
        countdown = {
          countdown-position = "top-right";
          justify = "right";
          countdown = 20;
        };
      };
      description = mdDoc ''
        Extra configuration to append to gtklock configuration file.
        Mostly used for appending module configurations.
      '';
      example = literalExpression ''
        countdown = {
          countdown-position = "top-right";
          justify = "right";
          countdown = 20;
        }
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = [cfg.package];

    xdg.configFile."gtklock/config.ini".source = pkgs.writeText "gtklock-config.ini" finalConfig;
  };
}
