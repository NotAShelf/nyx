{
  inputs',
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;

  ndg-pkgs = inputs'.ndg.packages;
  docs-html = ndg-pkgs.ndg-builder.override {
    rawModules = [config.modules];
  };

  cfg = config.modules.documentation;
in {
  config = mkIf cfg.enable {
    environment.etc = {
      "nyxos/options.html".source = docs-html.outPath;
    };
  };
}
