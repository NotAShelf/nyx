{lib, ...}: let
  inherit (lib.options) mkEnableOption;
in {
  options.modules.usrEnv.packages = {
    gui.enable = mkEnableOption "GUI package sets";
    cli.enable = mkEnableOption "CLI package sets";
    dev.enable = mkEnableOption "development related package sets";
  };
}
