{
  lib,
  stdenv,
  fetchzip,
  pkgs,
  ...
}:
stdenv.mkDerivation rec {
  pname = "catppuccin-gtk";
  version = "0.3.0";

  src = fetchzip {
    url = "https://github.com/catppuccin/gtk/releases/download/v0.3.0/Catppuccin-Mocha-Pink.zip";
    sha256 = "rlQuVs7jrdmyAraU1guE/tCzxjm2LnOpxKHUkS6spRg=";
    stripRoot = false;
  };

  propagatedUserEnvPkgs = with pkgs; [
    gnome.gnome-themes-extra
    gtk-engine-murrine
  ];

  installPhase = ''
    mkdir -p $out/share/themes/
    cp -r Catppuccin-Mocha-Pink $out/share/themes
  '';

  meta = {
    description = "Soothing pastel theme for GTK3";
    homepage = "https://github.com/catppuccin/gtk";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
  };
}
