{
  options,
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.options) mkEnableOption mkOption literalExpression;
  inherit (lib.types) nullOr path str package;
  inherit (lib.strings) optionalString;

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
  options.modules.documentation = {
    enable = mkEnableOption ''
      generation of internal module documentation for my system configuration. If enabled
      the module options will be rendered with pandoc and linked to `/etc/nyxos`
    '';

    warningsAreErrors = mkEnableOption ''
      enforcing build failure on missing option descriptions. While disabled, warnings will be
      displayed, but will not cause the build to fail.
    '';

    scss = mkOption {
      default = ./assets/default-style.scss;
      type = nullOr path;
      description = "CSS to apply to the docs";
    };

    scssExecutable = mkOption {
      default = lib.getExe' pkgs.sass "scss";
      example = literalExpression "${pkgs.dart-sass}/bin/sass";
      type = nullOr str;
      description = "Path to the sass executable";
    };

    templatePath = mkOption {
      default = ./assets/default-template.html;
      type = nullOr path;
      description = "The template to use for the docs";
    };

    # the following are exposed as module options for us to be able to build them in isolation
    # i.e. without building the rest of the system
    markdownPackage = mkOption {
      default = configMD;
      type = nullOr package;
      readOnly = true;
      description = "The package containing generated markdown";
    };

    htmlPackage = mkOption {
      default = docs-html;
      type = nullOr package;
      readOnly = true;
      description = "The package containing generated HTML";
    };

    # TODO: custom syntax highlighting via syntax.json path OR attrset to json
    # we love json. yaml is json. we should use yaml. yes.
  };
}
