{
  pkgs,
  lib,
  ...
}: {
  boot.binfmt = {
    emulatedSystems = [
      "aarch64-linux"
      "i686-linux"
    ];
    registrations.aarch64-linux = {
      interpreter = lib.mkForce "${pkgs.qemu}/bin/qemu-aarch64";
    };
  };
  nix.settings.extra-sandbox-paths = ["/run/binfmt" "${pkgs.qemu}"];
}
