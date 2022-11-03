{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: in {

  environment.variables = {
    BROWSER = "firefox";
  };

  programs = {
    ccache.enable = true;
    less.enable = true;
    hyprland = {
      # credits to IceDBorn and fufexan for this patch <3
      package = inputs.hyprland.packages.${pkgs.system}.default.override {
        nvidiaPatches = true;
        wlroots =
          inputs.hyprland.packages.${pkgs.system}.wlroots-hyprland.overrideAttrs
          (old: {
            patches =
              (old.patches or [])
              ++ [
                (pkgs.fetchpatch {
                  url = "https://aur.archlinux.org/cgit/aur.git/plain/0001-nvidia-format-workaround.patch?h=hyprland-nvidia-screenshare-git";
                  sha256 = "A9f1p5EW++mGCaNq8w7ZJfeWmvTfUm4iO+1KDcnqYX8=";
                })
              ];
          });
      };
    };
  };

  #upower.enable = true;
}
