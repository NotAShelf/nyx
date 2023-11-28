{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) optionals;
in {
  config = {
    # if nix-ld is not enabled, link standard libraries into /lib64 in order to provide
    # some degeree of compatibility with non-NixOS systems - this is not perfect
    # but has a potential to work for old and proprietary programs that look for it specifically
    # though the functionality is *usually* provided by nix-ld anyway, so this is only a fallback
    # for my minimal system
    systemd.tmpfiles.rules = optionals (!config.programs.nix-ld.dev.enable) [
      "L+ /lib64/ld-linux-x86-64.so.2 - - - - ${pkgs.glibc}/lib64/ld-linux-x86-64.so.2"
    ];
  };
}
