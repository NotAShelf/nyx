{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkForce;
in {
  fonts = {
    fontDir = {
      enable = true;
      decompressFonts = true;
    };

    fontconfig.enable = mkForce true;

    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
    ];
  };
}
