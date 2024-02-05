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
in {
  config = mkIf prg.element.enable {
    home.packages = [pkgs.element-desktop];

    xdg.configFile = {
      "Element/config.json".text = builtins.toJSON {
        default_server_config = {
          "m.homeserver" = {
            base_url = "https://notashelf.dev";
            server_name = "notashelf.dev";
          };

          "m.identity_server" = {base_url = "";};
        };

        show_labs_settings = true;
        default_theme = "dark";
      };
    };
  };
}
