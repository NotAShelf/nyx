{lib, ...}: let
  inherit (lib.kernel) yes no;
  inherit (lib.attrsets) mapAttrs;
  inherit (lib.modules) mkForce;
in {
  boot.kernelPatches = [
    {
      # recompile with AMD platform specific optimizations
      name = "AMD Platform Optimizations";
      patch = null; # no patch is needed, just apply the options
      extraStructuredConfig = mapAttrs (_: mkForce) {
        # enable compiler optimizations for AMD
        MNATIVE_AMD = yes;
        X86_USE_PPRO_CHECKSUM = yes;
        X86_AMD_PSTATE = yes;

        X86_EXTENDED_PLATFORM = no; # disable support for other x86 platforms
        X86_MCE_INTEL = no; # disable support for intel mce

        # Multigen LRU
        LRU_GEN = yes;
        LRU_GEN_ENABLED = yes;

        # Optimized for performance
        CC_OPTIMIZE_FOR_PERFORMANCE_O3 = yes;

        # collect CPU frequency statistics
        CPU_FREQ_STAT = yes;
      };
    }
  ];
}
