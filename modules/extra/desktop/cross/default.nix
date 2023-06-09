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
      emulatedSystems = ["aarch64-linux" "i686-linux"];
      registrations = {
        aarch64-linux = {
          interpreter = lib.mkForce "${pkgs.qemu}/bin/qemu-aarch64";
        };

        i686-linux = {
          interpreter = "${pkgs.qemu}/bin/qemu-i686";
        };
      };
    };
    nix.settings.extra-sandbox-paths = ["/run/binfmt" "${pkgs.qemu}"];
  };
}
