{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.options) mkEnableOption mkOption literalExample;
  inherit (lib.types) nullOr path str;
in {
  options.modules.documentation = {
    enable = mkEnableOption ''
      generation of internal module documentation for my system configuration. If enabled
      the module options will be rendered with pandoc and linked to `/etc/nyxos`
    '';

    warningsAreErrors = mkEnableOption "enforcing build failure on missing option descriptions";

    scss = mkOption {
      default = ./assets/default-style.scss;
      type = nullOr path;
      description = "CSS to apply to the docs";
    };

    scssExecutable = mkOption {
      default = lib.getExe' pkgs.sass "scss";
      example = literalExample "${pkgs.dart-sass}/bin/sass";
      type = nullOr str;
      description = "A package to use for the scss command";
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
