{
  pkgs,
  lib,
  ...
}: {
  config = {
    home = {
      packages = [pkgs.fastfetch];
    };

    xdg.configFile."fastfetch/config.jsonc".text = builtins.toJSON {
      "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";
      logo = {
        source = "nixos_small";
        padding = {
          left = 1;
          right = 3;
        };
      };
      display = {
        separator = " ";
        keyWidth = 14;
      };
      modules = [
        {
          type = "os";
          key = " system  ";
          format = "{3}";
        }
        {
          type = "kernel";
          key = " kernel  ";
          format = "{1} {2} ({4})";
        }
        {
          type = "uptime";
          key = " uptime  ";
        }
        {
          type = "wm";
          key = " wm      ";
        }
        {
          type = "command";
          key = "󰆧 packages";
          text = "(${lib.getExe' pkgs.nix "nix-store"} --query --requisites /run/current-system | wc -l | tr -d '\n') && echo ' (nix; /run/current-system)'";
        }
        {
          type = "memory";
          key = "󰍛 memory  ";
        }
        {
          type = "disk";
          key = "󱥎 storage ";
          format = "{1} / {2} ({3})";
          folders = "/";
        }
      ];
    };
  };
}
