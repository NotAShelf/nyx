{
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (osConfig) modules;

  env = modules.usrEnv;
  pkg = env.packages;
in {
  config = mkIf (pkg.cli.enable && pkg.cli.wayland.enable) {
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
        runtimeInputs = with pkgs; [tesseract grim slurp coreutils];
        text = ''
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
