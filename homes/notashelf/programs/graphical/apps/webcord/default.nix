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

    # TODO: maybe this should be under services/global because technically it's not an app
    # however arrpc is useless on its own (i.e. without webcord) and here it's merely a
    # companion app that we enable for rich presence.
    services.arrpc = {
      enable = true;
      package = pkgs.arrpc.overrideAttrs (_: {
        pname = "arrpc";
        version = "3.3.1";

        src = pkgs.fetchFromGitHub {
          owner = "OpenAsar";
          repo = "arrpc";
          rev = "b4796fffe3bf1b1361cc4781024349f7a4f9400e";
          hash = "sha256-iEfV85tRl2KyjodoaSxVHiqweBpLeiCAYWc8+afl/sA=";
        };
      });
    };
  };
}
