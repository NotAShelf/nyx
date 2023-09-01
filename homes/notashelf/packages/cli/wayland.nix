{
  osConfig,
  lib,
  pkgs,
  ...
}:
with lib; let
  ocr = pkgs.writeShellScriptBin "ocr" ''
    #!/bin/bash
    # generate a random id to identify the current ocr image
    id=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 6 | head -n 1)

    grim -g "$(slurp -w 0 -b eebebed2)" /tmp/ocr-$id.png && tesseract /tmp/ocr-$id.png /tmp/ocr-output && wl-copy < /tmp/ocr-output.txt && notify-send "OCR " "Text copied!" && rm /tmp/ocr-output.txt -f
  '';

  acceptedTypes = ["laptop" "desktop" "hybrid" "lite"];
in {
  config = mkIf ((lib.isAcceptedDevice osConfig acceptedTypes) && (lib.isWayland osConfig) && osConfig.modules.usrEnv.programs.cli.enable) {
    home.packages = with pkgs; [
      # CLI
      ocr
      grim
      slurp
      ocr
      grim
      wl-clipboard
      pngquant
      wf-recorder
    ];
  };
}
