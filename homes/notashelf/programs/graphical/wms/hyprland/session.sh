# disable shellcheck's shell check
# it'll be provided by writeShellScript
# shellcheck disable=2148

# session
export XDG_SESSION_TYPE=wayland
export XDG_SESSION_DESKTOP=hyprland
export XDG_CURRENT_DESKTOP=hyprland

# firefox
export MOZ_ENABLE_WAYLAND=1
export MOZ_DBUS_REMOTE=1

# qt
export QT_QPA_PLATFORM=wayland
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1

# gtk
export GDK_BACKEND=wayland

# sdl
export SDL_VIDEODRIVER=wayland

# java
export _JAVA_AWT_WM_NONREPARENTING=1
export JDK_JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=on -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel -Dswing.crossplatformlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel"

# other
export CLUTTER_BACKEND=wayland
export XCURSOR_SIZE=24
export NIXOS_OZONE_WL=1

# cursed dbus

dbus-update-activation-environment --systemd MOZ_ENABLE_WAYLAND MOZ_DBUS_REMOTE QT_QPA_PLATFORM QT_QPA_PLATFORMTHEME QT_WAYLAND_DISABLE_WINDOWDECORATION SDL_VIDEODRIVER _JAVA_AWT_WM_NONREPARENTING JDK_JAVA_OPTIONS XCURSOR_SIZE XCURSOR_THEME

# theme in dbus:
# QT_PLUGIN_PATH=<qt5ct>/lib/qt-ver/plugins + breeze will correctly set the theme.
# HOWEVER it won't find thumbnailers. For now the easiest way to deal with this, though definitely not
# the right one, is to just throw $PATH into dbus.
dbus-update-activation-environment --systemd PATH
