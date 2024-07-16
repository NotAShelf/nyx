{
  lib,
  stdenv,
  gccStdenv,
  buildLinux,
  fetchFromGitHub,
  kernelPatches,
  # Args to be passed to the kernel builder
  hostname ? "",
  suffix ? "shelf",
  ...
}: let
  inherit (lib.modules) mkForce mkOverride;
  inherit (lib.kernel) yes no freeform;
  inherit (lib.versions) pad;

  version = "6.9.9";
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

      # after booting to the new kernel
      # use zcat /proc/config.gz | grep -i "<value>"
      # to check if the kernel options are set correctly
      # Do note that values set in config/*.nix will override
      # those values in most cases.
      structuredExtraConfig = {
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
