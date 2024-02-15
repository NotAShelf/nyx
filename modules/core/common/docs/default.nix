{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;

  cfg = config.modules.documentation;
in {
  config = mkIf cfg.enable {
    environment.etc = {
      "nyxos/options.md".source = cfg.markdownPackage;
      "nyxos/options.html".source = cfg.htmlPackage;
    };
  };
}
