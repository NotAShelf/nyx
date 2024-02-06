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

    services.arrpc = {
      enable = true;
      package = pkgs.arrpc.overrideAttrs (_: {
        pname = "arrpc";
        version = "3.3.0";

        src = pkgs.fetchFromGitHub {
          owner = "OpenAsar";
          repo = "arrpc";
          rev = "c6e23e7eb733ad396d3eebc328404cc656fed581";
          sha256 = "sha256-OeEFNbmGp5SWVdJJwXZUkkNrei9jyuPc+4E960l8VRA=";
        };

        preInstall = ''
          mkdir -p $out/lib/node_modules/arRPC/
        '';

        postInstall = ''
          cp -rf src/* ext/* $out/lib/node_modules/arRPC/
        '';

        postFixup = with pkgs; ''
          ${nodejs}/bin/node --version
          makeWrapper ${nodejs}/bin/node $out/bin/arRPC \
            --add-flags $out/lib/node_modules/arrpc/src \
            --chdir $out/lib/node_modules/arrpc/src
        '';
      });
    };
  };
}
