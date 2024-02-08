{
  options,
  self,
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;

  cfg = config.modules.documentation;

  configMD =
    (pkgs.nixosOptionsDoc {
      options = options.modules;
      documentType = "appendix";
      inherit (cfg) warningsAreErrors;
    })
    .optionsCommonMark;

  docs-html = pkgs.callPackage ./manual.nix {inherit self configMD;};
in {
  config =
    /*
    mkIf cfg.enable
    */
    {environment.etc."nyxos".source = docs-html;};
}
