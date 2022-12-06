{
  lib,
  pkgs,
  ...
}: {
  # TODO: one day make this use custom themes from
  # https://github.com/spikespaz/dotfiles/tree/master/dotpkgs/plymouth-themes
  boot.plymouth.enable = true;
}
