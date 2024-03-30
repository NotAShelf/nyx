{lib, ...}: let
  inherit (lib.kernel) yes no;
  inherit (lib.attrsets) mapAttrs;
  inherit (lib.modules) mkForce;
in {
  boot.kernelPatches = [
    {
      # recompile with AMD platform specific optimizations
      name = "amd-platform-patches";
      patch = null; # no patch is needed, just apply the options
      extraStructuredConfig = mapAttrs (_: mkForce) {
        # enable compiler optimizations for AMD
        MNATIVE_AMD = yes;
        X86_USE_PPRO_CHECKSUM = yes;
        X86_AMD_PSTATE = yes;

        X86_EXTENDED_PLATFORM = no; # disable support for other x86 platforms
        X86_MCE_INTEL = no; # disable support for intel mce

        # multigen LRU
        LRU_GEN = yes;
        LRU_GEN_ENABLED = yes;

        # collect CPU frequency statistics
        CPU_FREQ_STAT = yes;

        # Optimized for performance
        # this is already set on the Xanmod kernel
        # CC_OPTIMIZE_FOR_PERFORMANCE_O3 = yes;
      };
    }
  ];
}
