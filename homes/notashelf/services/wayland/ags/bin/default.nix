{
  pkgs,
  lib,
  ...
}: let
  inherit (pkgs) writeShellScriptBin;

  ags-open-window = writeShellScriptBin "ags-open-window" ''
    ${lib.fileContents ./bash/open_window}
  '';

  ags-move-window = writeShellScriptBin "ags-move-window" ''
    ${lib.fileContents ./bash/move_window}
  '';

  ags-hyprctl-swallow = writeShellScriptBin "ags-hyprctl-swallow" ''
    ${lib.fileContents ./bash/hyprctl_swallow}
  '';
in {
  inherit ags-open-window ags-move-window ags-hyprctl-swallow;
}
