{
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (osConfig) modules;

  env = modules.usrEnv;
  prg = env.programs;

  # Fetching mocha theme from catppuccin/discord actually just fetches
  # a stylesheet that imports this url in typical Catppuccin nonsense.
  # Instead of adding this overhead (and a stupid sheet with a web import)
  # we can simply fetch the stylesheet that is being imported. In the future
  # I hope the Catppuccin team can get their heads out of their asses and
  # start publishing *actual releases* for once.
  # P.S. why does your stupid theme depend on yarn build? It's a stylesheet.
  catppuccin-mocha-css = pkgs.fetchurl {
    url = "https://catppuccin.github.io/discord/dist/catppuccin-mocha.theme.css";
    hash = "sha256-bhHJOsHcZIZ6NzJzdrmeQ0aG6nbYV6Sa92EXdLzgf1s=";
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
      "WebCord/Themes/mocha".source = catppuccin-mocha-css;
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
