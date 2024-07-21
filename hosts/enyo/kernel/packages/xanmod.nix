{
  lib,
  stdenv,
  gccStdenv,
  buildLinux,
  fetchFromGitHub,
  kernelPatches,
  # Args to be passed to the kernel builder
  hostname ? "",
  customSuffix ? "shelf",
  ...
}: let
  inherit (lib.modules) mkForce mkOverride;
  inherit (lib.kernel) yes no freeform;
  inherit (lib.versions) pad majorMinor;

  version = "6.10.0";
  vendorSuffix = "xanmod1";

  pname = "linux-xanmod";
  modDirVersion = pad 3 "${version}-${customSuffix}";

  xanmod_custom =
    (buildLinux {
      inherit pname version modDirVersion;

      stdenv = gccStdenv;

      src = fetchFromGitHub {
        owner = "xanmod";
        repo = "linux";
        rev = "refs/tags/${version}-${vendorSuffix}";
        hash = "sha256-zsBSG8YFxW4kKWRVtdG6M87FHJJ/8qlmq/qWAGYeieg=";
      };

      # Kernel derivations in Nixpkgs apply a set of patches to the kernel
      # in order to improve the reproducibility, security or compatibility
      # of the kernel. Patches below from pkgs.kernelPatches are passed to
      # the nixpkgs Xanmod builds, but since we build Xanmod from source here
      # they will be missing. Re-add those patches to the manual builder alongside
      # any other patches that I might need.
      kernelPatches = [
        kernelPatches.bridge_stp_helper
        kernelPatches.request_key_helper
      ];

      ignoreConfigErrors = true;

      # This is true by default. I need to figure out what this
      # *really* entails and then un-set it to disable unnecessary
      # preset configurations.
      enableCommonConfig = true;

      # after booting to the new kernel
      # use zcat /proc/config.gz | grep -i "<value>"
      # to check if the kernel options are set correctly
      # Do note that values set in config/*.nix will override
      # those values in most cases.
      structuredExtraConfig = {
        ### Xanmod Options
        # CPUFreq governor Performance
        CPU_FREQ_DEFAULT_GOV_PERFORMANCE = mkOverride 60 yes;
        CPU_FREQ_DEFAULT_GOV_SCHEDUTIL = mkOverride 60 no;

        # Full preemption
        PREEMPT = mkOverride 60 yes;
        PREEMPT_VOLUNTARY = mkOverride 60 no;

        # Preemptive Full Tickless Kernel at 250Hz
        HZ = freeform "250";
        HZ_250 = yes;
        HZ_1000 = no;

        # RCU_BOOST and RCU_EXP_KTHREAD
        RCU_EXPERT = yes;
        RCU_FANOUT = freeform "64";
        RCU_FANOUT_LEAF = freeform "16";
        RCU_BOOST = yes;
        RCU_BOOST_DELAY = freeform "0";
        RCU_EXP_KTHREAD = yes;

        ### Custom Options
        DEFAULT_HOSTNAME = freeform "${hostname}";

        GCC_PLUGINS = yes;
        BUG_ON_DATA_CORRUPTION = yes;

        EXPERT = yes;
        DEBUG_KERNEL = mkForce no;
        WERROR = no;
      };

      extraMeta = {
        broken = stdenv.isAarch64;
        branch = majorMinor version;
        description = ''
          Custom build of the Xanmod kernel with patches focusing on performance
          and security.
        '';
      };
    })
    .overrideAttrs (oa: {
      prePatch =
        (oa.prePatch or "")
        + ''
          # Without this override, buildLinux forces me to use the value set in
          # localversion which, as you can tell, is xanmod1. Replace it with my
          # own custom suffix to indicate this is a custom build.
          # ...and for bragging rights.
          echo "Replacing localversion with custom suffix"
          substituteInPlace localversion \
            --replace-fail "xanmod1" "${customSuffix}"
        '';
    });
in {
  inherit xanmod_custom;
}
