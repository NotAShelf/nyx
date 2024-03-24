{lib, ...}: let
  inherit (lib.kernel) yes no;
  inherit (lib.attrsets) mapAttrs;
  inherit (lib.modules) mkForce;
in {
  # after booting to the new kernel
  # use zcat /proc/config.gz | grep -i "<value>"
  # to check if the kernel options are set correctly
  boot.kernelPatches = [
    {
      # enable lockdown LSM
      name = "kernel-lockdown";
      patch = null;
      extraStructuredConfig = mapAttrs (_: mkForce) {
        SECURITY_LOCKDOWN_LSM = yes;
        MODULE_SIG = yes;
      };
    }
    {
      # recompile with AMD platform specific optimizations
      name = "AMD Patches";
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
        # FIXME: this is already set for the xanmod kernel
        # so it should be set if and only if the kernel package
        # is not xanmod under sys.boot
        # CC_OPTIMIZE_FOR_PERFORMANCE_O3 = yes;
        CPU_FREQ_STAT = yes;
      };

      # enable only support for upto 32 CPU threads in the kernel
      # this host has 16 cores and 32 threads
      extraConfig = ''
        NR_CPUS 32
      '';
    }
    {
      name = "module-compression";
      patch = null;
      extraConfig = ''
        KERNEL_ZSTD y
        MODULE_COMPRESS_XZ n
        MODULE_COMPRESS_ZSTD y
      '';
    }
  ];
}
