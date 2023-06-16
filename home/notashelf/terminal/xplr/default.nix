{
  pkgs,
  lib,
  osConfig,
  config,
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
      wl-clipboard-plugin = pkgs.fetchFromGitHub {
        owner = "sayanarijit";
        repo = "wl-clipboard.xplr";
        rev = "a3ffc87460c5c7f560bffea689487ae14b36d9c3";
        sha256 = "I4rh5Zks9hiXozBiPDuRdHwW5I7ppzEpQNtirY0Lcks=";
      };
      nuke-plugin = pkgs.fetchFromGitHub {
        owner = "Junker";
        repo = "nuke.xplr";
        rev = "f83a7ed58a7212771b15fbf1fdfb0a07b23c81e9";
        sha256 = "k/yre9SYNPYBM2W1DPpL6Ypt3w3EMO9dznHwa+fw/n0=";
      };
    in ''
      # TODO: get the version from xplr package's src.version
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
