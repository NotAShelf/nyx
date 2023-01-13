{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [./services.nix];
  nixpkgs.overlays = with inputs; [nixpkgs-wayland.overlay];
  environment.etc."greetd/environments".text = ''
    Hyprland
    sway
  '';

  environment = {
    # Experimental wayland-native wine
    # https://nixos.wiki/wiki/Wine
    systemPackages = with pkgs; [wineWowPackages.waylandFull];
    variables = {
      NIXOS_OZONE_WL = "1";
      __GL_GSYNC_ALLOWED = "0";
      __GL_VRR_ALLOWED = "0";
      _JAVA_AWT_WM_NONEREPARENTING = "1";
      DISABLE_QT5_COMPAT = "0";
      GDK_BACKEND = "wayland,x11";
      ANKI_WAYLAND = "1";
      DIRENV_LOG_FORMAT = "";
      WLR_DRM_NO_ATOMIC = "1";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      QT_QPA_PLATFORM = "wayland;xcb";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      QT_QPA_PLATFORMTHEME = "qt5ct";
      QT_STYLE_OVERRIDE = "kvantum";
      MOZ_ENABLE_WAYLAND = "1";
      WLR_BACKEND = "vulkan";
      XDG_SESSION_TYPE = "wayland";
      SDL_VIDEODRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";
      WLR_DRM_DEVICES = "/dev/dri/card1:/dev/dri/card0";
    };
    loginShellInit = ''
      dbus-update-activation-environment --systemd DISPLAY
      eval $(ssh-agent)
      eval $(gnome-keyring-daemon --start --components=ssh)
    '';
  };

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau-va-gl
      ];

      extraPackages32 = with pkgs.pkgsi686Linux; [
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
    pulseaudio.support32Bit = true;
  };

  xdg.portal = {
    extraPortals = with inputs; [
      xdg-portal-hyprland.packages.${pkgs.system}.default
    ];
    wlr = {
      enable = false;
      settings = {
        screencast = {
          max_fps = 60;
          chooser_type = "simple";
          chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
        };
      };
    };
  };
}
