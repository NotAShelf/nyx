{
  lib,
  pkgs,
  ...
}: {
  environment.variables = let
    qmlPackages = with pkgs; [
      plasma5Packages.qqc2-desktop-style
      plasma5Packages.kirigami2
    ];

    qtVersion = pkgs.qt515.qtbase.version;
  in {
    "QML2_IMPORT_PATH" = "${lib.concatStringsSep ":" (builtins.map (p: "${p}/lib/qt-${qtVersion}/qml") qmlPackages)}";
  };
}
