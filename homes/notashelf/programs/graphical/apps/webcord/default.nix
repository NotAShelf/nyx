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
    rev = "fac2d63e39b17cec988cb143f09ba5d55d195275";
    hash = "sha256-XgRVTXCKX+YXujGvqy1C0gNlUTMLgaVFakMplD67UVo=";
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
        version = "0-unstable-2024-04-24";
        src = openasar-git;

        patches = [
          # Improve game detection for Linux
          # <https://github.com/OpenAsar/arrpc/pull/92>
          (pkgs.fetchpatch {
            url = "https://patch-diff.githubusercontent.com/raw/OpenAsar/arrpc/pull/92.patch";
            hash = "sha256-AHa4FzXJn7bcZ+35DdmAHP/4X3g7//mwp/ggIKvalpw=";
          })
        ];
      };
    };
  };
}
