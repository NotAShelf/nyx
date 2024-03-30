{lib, ...}: let
  inherit (lib.kernel) yes no module;
  inherit (lib.attrsets) mapAttrs;
  inherit (lib.modules) mkForce;
in {
  boot.kernelPatches = [
    {
      # <https://www.phoronix.com/news/Google-BBRv3-Linux>
      # <https://github.com/google/bbr/blob/v3/README.md>
      name = "bbr-and-cake";
      patch = null;
      extraStructuredConfig = mapAttrs (_: mkForce) {
        TCP_CONG_CUBIC = module;
        NET_SCH_CAKE = module;

        # xanmod defaults
        TCP_CONG_BBR = yes;
        DEFAULT_BBR = yes;
      };
    }
    {
      name = "zstd-module-compression";
      patch = null;
      extraStructuredConfig = mapAttrs (_: mkForce) {
        KERNEL_ZSTD = yes;
        MODULE_COMPRESS_ZSTD = yes;
        MODULE_COMPRESS_XZ = no;
      };
    }
  ];
}
