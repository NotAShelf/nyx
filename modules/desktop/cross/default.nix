{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  sys = config.modules.system;
in {
  config = mkIf (sys.emulation.enable) {
    boot.binfmt = {
      emulatedSystems = [
        "aarch64-linux"
      ];
      registrations = {
        aarch64-linux = {
          interpreter = lib.mkForce "${pkgs.qemu}/bin/qemu-aarch64";
        };
      };
    };
    nix.settings.extra-sandbox-paths = ["/run/binfmt" "${pkgs.qemu}"];
  };
}
