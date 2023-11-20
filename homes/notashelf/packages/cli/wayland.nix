{
  osConfig,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  dev = osConfig.modules.device;
  env = osConfig.modules.usrEnv;
  acceptedTypes = ["laptop" "desktop" "hybrid" "lite"];
in {
  config = mkIf ((builtins.elem dev.type acceptedTypes) && env.isWayland) {
    home.packages = with pkgs; [
      # CLI
      grim
      slurp
      grim
      wl-clipboard
      pngquant
      wf-recorder
      (pkgs.writeShellApplication {
        name = "ocr";
        runtimeInputs = with pkgs; [tesseract grim slurp];
        text = ''
          set -x

          echo "Generating a random ID..."
          id=$(tr -dc 'a-zA-Z0-9' </dev/urandom | fold -w 6 | head -n 1 || true)
          echo "Image ID: $id"

          echo "Taking screenshot..."
          grim -g "$(slurp -w 0 -b eebebed2)" /tmp/ocr-"$id".png

          echo "Running OCR..."
          tesseract /tmp/ocr-"$id".png - | wl-copy
          echo -en "File saved to /tmp/ocr-'$id'.png\n"


          echo "Sending notification..."
          notify-send "OCR " "Text copied!"

          echo "Cleaning up..."
          rm /tmp/ocr-"$id".png -vf

        '';
      })
    ];
  };
}
