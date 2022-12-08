{
  lib,
  stdenv,
  fetchzip,
  pkgs,
  ...
}:
stdenv.mkDerivation rec {
  pname = "cattpuccin-gtk";
  version = "0.3.0";

  src = fetchzip {
    url = "https://github.com/catppuccin/gtk/releases/download/v0.3.0/Catppuccin-Mocha-Teal.zip";
    sha256 = "SRS8igz06y+A1bYObtcyPPsOUn3WrOuhVsXkhj1l1KY=";
    stripRoot = false;
  };

  propagatedUserEnvPkgs = with pkgs; [
    gnome.gnome-themes-extra
    gtk-engine-murrine
  ];

  installPhase = ''
    mkdir -p $out/share/themes/
    cp -r Catppuccin-Mocha-Teal $out/share/themes
  '';

  meta = {
    description = "Soothing pastel theme for GTK3";
    homepage = "https://github.com/catppuccin/gtk";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
    maintainers = [lib.maintainers.sioodmy];
  };
}
