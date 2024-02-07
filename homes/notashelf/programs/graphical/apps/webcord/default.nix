{
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (osConfig) modules;

  sys = modules.system;
  prg = sys.programs;

  catppuccin-mocha = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "discord";
    rev = "20abe29b3f0f7c59c4878b1bf6ceae41aeac9afd";
    hash = "sha256-Gjrv1VayPfjcsfSmGJdJTA8xEX6gXhpgTLJ2xrSNcEo=";
  };
in {
  config = mkIf prg.webcord.enable {
    home.packages = [
      pkgs.webcord-vencord # webcord with vencord extension installed
    ];

    xdg.configFile = {
      "WebCord/Themes/mocha" = {
        source = "${catppuccin-mocha}/themes/mocha.theme.css";
      };
    };

    services.arrpc.enable = true;
  };
}
