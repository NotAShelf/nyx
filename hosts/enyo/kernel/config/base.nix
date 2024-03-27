{lib, ...}: let
  inherit (lib.kernel) yes no module freeform;
  inherit (lib.attrsets) mapAttrs;
  inherit (lib.modules) mkForce;
in {
  # after booting to the new kernel
  # use zcat /proc/config.gz | grep -i "<value>"
  # to check if the kernel options are set correctly
  boot.kernelPatches = [
    {
      # base
      name = "Base Config Patches";
      patch = null;
      extraStructuredConfig = mapAttrs (_: mkForce) {
        LOCALVERSION = freeform "-shelf"; # we can't use this because we don't provide modDirVersion
        EXPERT = yes;
        WERROR = no;
      };
    }
    {
      # <https://www.phoronix.com/news/Google-BBRv3-Linux>
      # <https://github.com/google/bbr/blob/v3/README.md>
      name = "BBR & Cake";
      patch = null;
      extraStructuredConfig = mapAttrs (_: mkForce) {
        TCP_CONG_CUBIC = module;
        TCP_CONG_BBR = yes;
        DEFAULT_BBR = yes;
        NET_SCH_CAKE = module;
      };
    }
    {
      name = "Module Compression via ZSTD";
      patch = null;
      extraStructuredConfig = mapAttrs (_: mkForce) {
        KERNEL_ZSTD = yes;
        MODULE_COMPRESS_ZSTD = yes;
        MODULE_COMPRESS_XZ = no;
      };
    }
  ];
}
