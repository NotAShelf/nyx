{
  pkgs,
  lib,
  ...
}: {
  xdg.configFile."kdeglobals".source = "${pkgs.catppuccin-kde}/Resources/Base.colors";
  qt = {
    enable = true;
    # platformTheme = "gtk"; # just an override for QT_QPA_PLATFORMTHEME, takes "gtk" or "gnome"
    style = {
      package = pkgs.catppuccin-kde;
      name = "Catpuccin-Mocha-Dark";
    };
  };

  # credits: yavko
  # catppuccin theme for qt-apps
  home.packages = with pkgs; [libsForQt5.qtstyleplugin-kvantum];

  home.sessionVariables = {
    #QT_QPA_PLATFORMTHEME = "kvantum"; # can't be used alongside kvantum, nix above knows why
    QT_STYLE_OVERRIDE = "kvantum";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    DISABLE_QT5_COMPAT = "0";

    # tell calibre to use the dark theme, because the light one hurts my eyes
    CALIBRE_USE_DARK_PALETTE = "1";
  };

  xdg.configFile."Kvantum/catppuccin/catppuccin.kvconfig".source = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/catppuccin/Kvantum/main/src/Catppuccin-Mocha-Blue/Catppuccin-Mocha-Blue.kvconfig";
    sha256 = "1f8xicnc5696g0a7wak749hf85ynfq16jyf4jjg4dad56y4csm6s";
  };

  xdg.configFile."Kvantum/catppuccin/catppuccin.svg".source = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/catppuccin/Kvantum/main/src/Catppuccin-Mocha-Blue/Catppuccin-Mocha-Blue.svg";
    sha256 = "0vys09k1jj8hv4ra4qvnrhwxhn48c2gxbxmagb3dyg7kywh49wvg";
  };

  xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
    [General]
    theme=catppuccin

    [Applications]
    catppuccin=qt5ct, org.kde.dolphin, org.kde.kalendar, org.qbittorrent.qBittorrent, hyprland-share-picker, dolphin-emu, Nextcloud, nextcloud
  '';

  /*
  xdg.configFile."qt5ct/qt5ct.conf".text = ''
    [Appearance]
    color_scheme_path=${pkgs.qt5ct}/share/qt5ct/colors/darker.conf
    custom_palette=true
    icon_theme=Papirus-Dark
    standard_dialogs=default
    style=kvantum-dark

    [Fonts]
    fixed=@Variant(\0\0\0@\0\0\0\f\0L\0\x65\0x\0\x65\0n\0\x64@(\0\0\0\0\0\0\xff\xff\xff\xff\x5\x1\0\x32\x10)
    general=@Variant(\0\0\0@\0\0\0\f\0L\0\x65\0x\0\x65\0n\0\x64@(\0\0\0\0\0\0\xff\xff\xff\xff\x5\x1\0\x32\x10)

    [Interface]
    activate_item_on_single_click=1
    buttonbox_layout=0
    cursor_flash_time=1000
    dialog_buttons_have_icons=1
    double_click_interval=400
    gui_effects=@Invalid()
    keyboard_scheme=2
    menus_have_icons=true
    show_shortcuts_in_context_menus=true
    stylesheets=@Invalid()
    toolbutton_style=4
    underline_shortcut=1
    wheel_scroll_lines=3

    [SettingsWindow]
    geometry=@ByteArray(\x1\xd9\xd0\xcb\0\x3\0\0\0\0\0\0\0\0\0\0\0\0\a\x7f\0\0\x4\x37\0\0\0\0\0\0\0\0\0\0\x2\xde\0\0\x2\x44\0\0\0\0\x2\x4\0\0\a\x80\0\0\0\0\0\0\0\0\0\0\a\x7f\0\0\x4\x37)

    [Troubleshooting]
    force_raster_widgets=1
    ignored_applications=@Invalid()
  '';
  */
}
