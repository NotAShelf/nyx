{
  self,
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (builtins) readFile;
  inherit (lib) compileSCSS;
  inherit (lib.modules) mkIf;

  inherit (osConfig) modules;
  env = modules.usrEnv;
in {
  imports = [self.homeManagerModules.gtklock];
  config = mkIf env.programs.screenlock.gtklock.enable {
    programs.gtklock = {
      enable = true;
      package = pkgs.gtklock;

      config = {
        modules = [
          "${pkgs.gtklock-powerbar-module.outPath}/lib/gtklock/powerbar-module.so"
        ];

        style = readFile (compileSCSS pkgs {
          name = "gtklock-dark";
          path = ./styles/dark.scss;
        });
      };

      extraConfig = {};
    };
  };
}
