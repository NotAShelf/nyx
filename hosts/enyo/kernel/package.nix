{
  lib,
  stdenv,
  gccStdenv,
  buildLinux,
  fetchFromGitHub,
  # Args to be passed to the kernel builder
  hostname ? "",
  ...
}: let
  inherit (lib.modules) mkForce;
  inherit (lib.kernel) yes no freeform;
  inherit (lib.versions) pad;

  version = "6.9.9";
  suffix = "shelf";
  modDirVersion = pad 3 "${version}-${suffix}";

  xanmod_custom =
    (buildLinux {
      pname = "linux-xanmod";
      inherit version suffix modDirVersion;

      stdenv = gccStdenv;

      src = fetchFromGitHub {
        owner = "xanmod";
        repo = "linux";
        rev = "refs/tags/${version}-${suffix}";
        hash = "sha256-ZEU1RIgJ0ckyITFWZndEzXYwnTF39OviLxL9S5dEea4=";
      };

      # Those patches are passed to Xanmod derivations while being called
      # from top-level. Since we build Xanmod from source now, we need to
      # source the patches manually. For consistency, I also vendor the
      # patches in patches/ alongside my custom (future) patches.
      kernelPatches = [
        {
          name = "bridge-stp-helper";
          patch = ./patches/bridge-stp-helper.patch;
        }
        {
          name = "request-key-helper";
          patch = ./patches/request-key-helper.patch;
        }
      ];

      extraMakeFlags = ["KCFLAGS=-DAMD_PRIVATE_COLOR"];
      ignoreConfigErrors = true;

      # after booting to the new kernel
      # use zcat /proc/config.gz | grep -i "<value>"
      # to check if the kernel options are set correctly
      # Do note that values set in config/*.nix will override
      # those values in most cases.
      structuredExtraConfig = {
        # CPUFreq governor Performance
        CPU_FREQ_DEFAULT_GOV_PERFORMANCE = lib.mkOverride 60 yes;
        CPU_FREQ_DEFAULT_GOV_SCHEDUTIL = lib.mkOverride 60 no;

        # Full preemption
        PREEMPT = lib.mkOverride 60 yes;
        PREEMPT_VOLUNTARY = lib.mkOverride 60 no;

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

        GCC_PLUGINS = yes;
        BUG_ON_DATA_CORRUPTION = yes;

        EXPERT = yes;
        DEBUG_KERNEL = mkForce no;
        WERROR = no;

        DEFAULT_HOSTNAME = freeform "${hostname}";
      };

      extraMeta.broken = stdenv.isAarch64;
    })
    .overrideAttrs {
      patchPhase = ''
        runHook prePatch

        # Without this override, buildLinux forces me to use the value set in
        # localversion which, as you can tell, is xanmod1. Replace it with my
        # own custom suffix to indicate this is a custom build.
        # And for extra rep.
        substituteInPlace localversion \
          --replace-fail "xanmod1" "${suffix}"

        runHook postPatch
      '';
    };
in {
  inherit xanmod_custom;
}
