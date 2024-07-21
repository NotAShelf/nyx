{
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (osConfig) modules;

  env = modules.usrEnv;
  pkg = env.packages;
in {
  config = mkIf pkg.dev.enable {
    home.packages = [
      (pkgs.writeShellApplication {
        name = "pdflatexmk";
        runtimeInputs = [pkgs.texlivePackages.latexmk];
        text = ''
          latexmk -pdf "$@" && latexmk -c "$@"
        '';
      })
    ];
  };
}
