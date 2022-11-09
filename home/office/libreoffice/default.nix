{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: with lib; let
  office = libreoffice-fresh-unwrapped;
in {
  
  environment.sessionVariables = {
    PYTHONPATH = "${office}/lib/libreoffice/program";
    URE_BOOTSTRAP = "vnd.sun.star.pathname:${office}/lib/libreoffice/program/fundamentalrc";
  };
  
  home.packages = with pkgs; [
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-wlr
    libnotify
    wf-recorder
    brightnessctl
    pamixer
    python39Packages.requests
    slurp
    tesseract5
    ocr
    grim
    screenshot
    wl-clipboard
    pngquant
  ];

  # xdg.configFile."hypr/hyprland.conf".source = ./hyprland.conf;
  # systemd.user.services.swayidle.Install.WantedBy = lib.mkForce ["hyprland-session.target"];

  wayland.windowManager.hyprland = {
    enable = true;
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
    systemdIntegration = true;
    extraConfig = builtins.readFile ./hyprland.conf;
  };

  services.gammastep = {
    enable = true;
    provider = "geoclue2";
  };

  systemd.user.services = {
    swaybg = mkService {
      Unit.Description = "Wallpaper chooser";
      Service.ExecStart = "${pkgs.swaybg}/bin/swaybg -i ${./wall.png}";
    };
  };
}
