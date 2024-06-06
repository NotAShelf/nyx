{
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (osConfig) modules;

  sys = modules.system;
  prg = sys.programs;

  catppuccin-mocha = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "discord";
    rev = "7d9808eaf663f9c61824fcd1be810dce0fe4a7af";
    hash = "sha256-wIRr+LnOp9PW7v5xOqpdB6AjqINBlYFkoGRorYkRC2I=";
  };

  openasar-git = pkgs.fetchFromGitHub {
    owner = "OpenAsar";
    repo = "arrpc";
    rev = "c62ec6a04c8d870530aa6944257fe745f6c59a24";
    hash = "sha256-wIRr+LnOp9PW7v5xOqpdB6AjqINBlYFkoGRorYkRC2I=";
  };
in {
  config = mkIf prg.webcord.enable {
    home.packages = [
      pkgs.webcord-vencord # webcord with vencord extension installed
    ];

    xdg.configFile = {
      "WebCord/Themes/mocha".source = "${catppuccin-mocha}/themes/mocha.theme.css";
    };

    # TODO: maybe this should be under services/global because technically it's not an app
    # however arrpc is useless on its own (i.e. without webcord) and here it's merely a
    # companion app that we enable for rich presence.
    services.arrpc = {
      enable = true;
      package = pkgs.arrpc.overrideAttrs {
        pname = "arrpc";
        version = "3.4.0";

        src = openasar-git;
      };
    };
  };
}
