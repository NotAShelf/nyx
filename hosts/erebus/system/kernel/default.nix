{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.kernel) no;
in {
  kernel-offline = pkgs.linuxPackagesFor (pkgs.linux_latest.override {
    ignoreConfigErrors = true;
    extraStructuredConfig = {
      CONFIG_NET = lib.kernel.no;
    };
  });
}
