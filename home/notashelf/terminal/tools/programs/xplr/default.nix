{
  pkgs,
  lib,
  osConfig,
  ...
}: let
  device = osConfig.modules.device;
  acceptedTypes = ["laptop" "desktop" "hybrid" "server" "lite"];
in {
  config = lib.mkIf (builtins.elem device.type acceptedTypes) {
    home.packages = with pkgs; [
      xplr
    ];

    xdg.configFile."xplr/init.lua".text = let
      # get plugin derivations from plugins.nix so that this file remains clean
      inherit (import ./plugins.nix pkgs) wl-clipboard-plugin nuke-plugin;
    in ''
      version = '${pkgs.xplr.version}'

      package.path =
      "${wl-clipboard-plugin}/init.lua;" ..
      "${nuke-plugin}/init.lua;" ..
      package.path


      require("wl-clipboard").setup{
        copy_command = "wl-copy -t text/uri-list",
        paste_command = "wl-paste",
        keep_selection = true,
      }

      require("nuke").setup{
        pager = "less -R",
        open = {
          run_executables = true, -- default: false
          custom = {
            {extension = "jpg", command = "imv {}"},
            {extension = "pdf", command = "zathura {}"},
            {mime_regex = "^video/.*", command = "mpv {}"},
            {mime_regex = ".*", command = "xdg-open {}"}
          }
        },

        view = {
          show_line_numbers = true, -- default: false
        },

        smart_view = {
          custom = {
            {extension = "so", command = "ldd -r {} | less"},
          },
        }
      }
    '';
  };
}
