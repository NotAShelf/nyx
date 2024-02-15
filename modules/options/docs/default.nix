{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.options) mkEnableOption mkOption literalExpression;
  inherit (lib.types) nullOr path str;
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

    # TODO: custom syntax highlighting via syntax.json path OR attrset to json
    # we love json. yaml is json. we should use yaml. yes.
  };
}
