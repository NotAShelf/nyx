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
      # NOTE: we can't yet use overrideAttrs on arrpc becausae the derivation is
      # vastly different between v3.2.0 and v3.3.0. this builds the package
      # from source very similarly to the active PR that I have made
      # <https://github.com/NixOS/nixpkgs/pull/286659>
      package = pkgs.buildNpmPackage {
        pname = "arrpc";
        version = "3.3.0";

        src = pkgs.fetchFromGitHub {
          owner = "OpenAsar";
          repo = "arrpc";
          # not tagged for some reason.
          # revision for 3.3.0
          rev = "c6e23e7eb733ad396d3eebc328404cc656fed581";
          hash = "sha256-OeEFNbmGp5SWVdJJwXZUkkNrei9jyuPc+4E960l8VRA=";
        };

        npmDepsHash = "sha256-YlSUGncpY0MyTiCfZcPsfcNx3fR+SCtkOFWbjOPLUzk=";
        dontNpmBuild = true;

        meta = {
          # required for the systemd service to work properly
          mainProgram = "arrpc";
        };
      };
    };
  };
}
