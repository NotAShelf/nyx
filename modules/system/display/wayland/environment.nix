{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  sys = config.modules.system.video;
  env = config.modules.usrEnv;
in {
  config = mkIf (sys.enable && env.isWayland) {
    environment.etc."greetd/environments".text = ''
      Hyprland
      zsh
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
        GDK_BACKEND = "wayland,x11";
        ANKI_WAYLAND = "1";
        QT_AUTO_SCREEN_SCALE_FACTOR = "1";
        QT_QPA_PLATFORM = "wayland;xcb";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        QT_QPA_PLATFORMTHEME = "qt5ct";
        QT_STYLE_OVERRIDE = "kvantum";
        DISABLE_QT5_COMPAT = "0";
        MOZ_ENABLE_WAYLAND = "1";
        XDG_SESSION_TYPE = "wayland";
        SDL_VIDEODRIVER = "wayland";
        CLUTTER_BACKEND = "wayland";
        #WLR_DRM_NO_ATOMIC = "1";
        #WLR_BACKEND = "vulkan";
      };
    };
  };
}
