{pkgs, ...}: {
  config.modules.style = {
    forceGtk = true;
    useKvantum = false;

    colorScheme = {
      name = "Catppuccin Mocha";
      slug = "catppccin-mocha";
    };

    pointerCursor = {
      package = pkgs.catppuccin-cursors.mochaDark;
      name = "Catppuccin-Mocha-Dark-Cursors";
      size = 24;
    };

    qt = {
      style = {
        package = pkgs.catppuccin-kde;
        name = "Catppuccin-Mocha-Dark";
      };
    };

    gtk = {
      usePortal = true;
      theme = {
        name = "Catppuccin-Mocha-Standard-Blue-dark";
        package = pkgs.catppuccin-gtk.override {
          size = "standard";
          accents = ["blue"];
          variant = "mocha";
          tweaks = ["normal"];
        };
      };

      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.catppuccin-papirus-folders.override {
          accent = "blue";
          flavor = "mocha";
        };
      };

      font = {
        name = "Lexend";
        size = 14;
      };
    };
  };
}
