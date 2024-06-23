{pkgs, ...}: let
  inherit (builtins) concatStringsSep map;

  inherit (pkgs.kdePackages) qqc2-desktop-style qtbase;
  inherit (pkgs.libsForQt5) kirigami2;

  qmlPackages = [
    qqc2-desktop-style
    kirigami2
  ];
in {
  environment.variables = {
    "QML2_IMPORT_PATH" = "${concatStringsSep ":" (map (pkg: "${pkg}/lib/qt-${qtbase.version}/qml") qmlPackages)}";
  };
}
