{
  hyprland,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.meta) getExe';
in
  pkgs.writeShellScriptBin "hyprland" ''
    ${builtins.readFile ./session.sh}
    ${getExe' hyprland.packages.default "Hyprland"} $@
  ''
