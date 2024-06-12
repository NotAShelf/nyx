{lib, ...}: let
  inherit (lib.options) mkEnableOption;
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
  };
}
