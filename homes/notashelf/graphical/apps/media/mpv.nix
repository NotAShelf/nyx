{
  pkgs,
  lib,
  osConfig,
  self,
  ...
}: let
  inherit (lib) mkIf;

  inherit (self.packages.${pkgs.system}) anime4k;
  low1k = import ./low1k.nix {inherit anime4k;};
  dev = osConfig.modules.device;
  acceptedTypes = ["desktop" "laptop" "hybrid"];
in {
  config = mkIf (builtins.elem dev.type acceptedTypes) {
    programs.mpv = {
      enable = true;
      bindings =
        {
          Y = "add sub-scale +0.1"; # increase subtitle font size
          G = "add sub-scale -0.1"; # decrease subtitle font size
          y = "sub_step -1"; # immediately display next subtitle
          g = "sub_step +1"; # previous
          R = "cycle_values window-scale 2 0.5 1"; # switch between 2x, 1/2, unresized window size
        }
        // low1k;
      config = {
        audio-display = false;
        force-window = true;
        hidpi-window-scale = false;
        hwdec = "auto";
        keep-open = true;
        keep-open-pause = false;
        osd-on-seek = false;
        profile = "gpu-hq";
        script-opts = "osc-seekbarstyle=knob,osc-deadzonesize=1,osc-minmousemove=1";
        slang = "chi";
        sub-auto = "fuzzy";
        sub-codepage = "gbk";
        osc = "no";
        osd-bar = "no";
        border = "no";
      };
      scripts = with pkgs.mpvScripts; [
        #cutter
        mpris
        thumbnail
        sponsorblock
        uosc
      ];
    };
  };
}
