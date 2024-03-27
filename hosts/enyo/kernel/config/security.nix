{lib, ...}: let
  inherit (lib.kernel) yes;
  inherit (lib.attrsets) mapAttrs;
  inherit (lib.modules) mkForce;
in {
  boot.kernelPatches = [
    {
      # enable lockdown LSM
      name = "kernel-lockdown-lsm";
      patch = null;
      extraStructuredConfig = mapAttrs (_: mkForce) {
        SECURITY_LOCKDOWN_LSM = yes;
        MODULE_SIG = yes;
      };
    }
  ];
}
