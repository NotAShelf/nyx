{
  options,
  self,
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.strings) optionalString;
  inherit (lib.meta) getExe;

  cfg = config.modules.documentation;

  configMD =
    (pkgs.nixosOptionsDoc {
      options = options.modules;
      documentType = "appendix";
      inherit (cfg) warningsAreErrors;
    })
    .optionsCommonMark;

  compileCss = pkgs.runCommandLocal "compile-css" {} ''
    mkdir -p $out
    ${cfg.scssExecutable} -t expanded ${cfg.scss} > $out/sys-docs-style.css

  '';

  docs-html = pkgs.runCommand "nyxos-docs" {} (
    ''
      ${getExe pkgs.pandoc} \
        --sandbox \
        --from commonmark \
        --to html \
        --metadata title="NyxOS Docs" \
        --toc \
        --standalone \
    ''
    + optionalString (cfg.templatePath != null) ''--template ${cfg.templatePath} \''
    + optionalString (cfg.scss != null) ''--css=${compileCss.outPath}/sys-docs-style.css \''
    + "${configMD} -o $out"
  );
in {
  config =
    /*
    mkIf cfg.enable
    */
    {environment.etc."nyxos".source = docs-html;};
}
