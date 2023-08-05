{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkDefault;

  cfg = config.modules.style;
in {
  config =
    mkIf (cfg.theme == "catppuccin-mocha") {};
}
