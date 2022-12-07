{
  config,
  lib,
  pkgs,
  ...
}: {
  # TODO: one day make this use custom themes from
  # https://github.com/spikespaz/dotfiles/tree/master/dotpkgs/plymouth-themes
  #boot.plymouth.enable = true;

  # configure plymouth theme
  # <https://github.com/adi1090x/plymouth-themes>
  boot.plymouth = let
    pack = 3;
    theme = "hud_3";
  in {
    enable = true;
    themePackages = [
      (pkgs.nixos-plymouth.override {inherit pack theme;})
    ];
    inherit theme;
  };
}
