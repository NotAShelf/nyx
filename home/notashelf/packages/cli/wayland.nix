{
  osConfig,
  lib,
  pkgs,
  ...
}:
with lib; let
  ocr = pkgs.writeShellScriptBin "ocr" ''
    #!/bin/bash
    grim -g "$(slurp -w 0 -b eebebed2)" /tmp/ocr.png && tesseract /tmp/ocr.png /tmp/ocr-output && wl-copy < /tmp/ocr-output.txt && notify-send "OCR " "Text copied!" && rm /tmp/ocr-output.txt -f
  '';

  device = osConfig.modules.device;
  env = osConfig.modules.usrEnv;
  acceptedTypes = ["laptop" "desktop" "hybrid" "lite"];
in {
  config = mkIf ((builtins.elem device.type acceptedTypes) && (env.isWayland)) {
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
