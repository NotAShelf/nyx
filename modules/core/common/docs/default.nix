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

  docs-html = pkgs.runCommand "nyxos-docs" {nativeBuildInputs = [pkgs.pandoc];} (
    ''
      # convert to pandoc markdown instead of using commonmark directly,
      # as the former automatically generates heading ids and TOC links.
      pandoc \
        --from commonmark \
        --to markdown \
        ${configMD} |


      # convert pandoc markdown to html using our own template and css files
      # where available. --sandbox is passed for extra security.
      pandoc \
       --sandbox \
       --from markdown \
       --to html \
       --metadata title="NyxOS Docs" \
       --toc \
       --standalone \
    ''
    + optionalString (cfg.templatePath != null) ''--template ${cfg.templatePath} \''
    + optionalString (cfg.scss != null) ''--css=${compileCss.outPath}/sys-docs-style.css \''
    + "-o $out"
  );
in {
  config = mkIf cfg.enable {
    environment.etc = {
      "nyxos/options.md".source = configMD;
      "nyxos/options.html".source = docs-html;
    };
  };
}
