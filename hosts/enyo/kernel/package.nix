{
  lib,
  fetchFromGitHub,
  linuxKernel,
  ccacheStdenv,
  buildPackages,
  ...
}: let
  inherit (lib.kernel) yes no;
  inherit (lib.attrsets) mapAttrs recursiveUpdate;
  inherit (lib.modules) mkForce;

  version = "6.8.2";
  suffix = "xanmod1";
  modDirVersion = "${version}-${suffix}";

  xanmod_custom = linuxKernel.kernels.linux_xanmod_latest.override {
    inherit version suffix modDirVersion;

    # https://github.com/xanmod/linux
    src = fetchFromGitHub {
      owner = "xanmod";
      repo = "linux";
      rev = "refs/tags/${version}-xanmod1";
      hash = "sha256-JddPg/EWJZq5EIemcaULM5c6yLGkfb2E6shxxq37N3M=";
    };

    # poor attempt to make kernel builds use ccache
    stdenv = ccacheStdenv;
    buildPackages = recursiveUpdate buildPackages {
      stdenv = ccacheStdenv;
    };

    extraMakeFlags = ["KCFLAGS=-DAMD_PRIVATE_COLOR"];
    ignoreConfigErrors = true;

    # after booting to the new kernel
    # use zcat /proc/config.gz | grep -i "<value>"
    # to check if the kernel options are set correctly
    extraStructuredConfig = mapAttrs (_: mkForce) {
      EXPERT = yes;
      DEBUG_KERNEL = no;
      WERROR = no;

      GCC_PLUGINS = yes;
      BUG_ON_DATA_CORRUPTION = yes;
    };
  };
in {
  inherit xanmod_custom;
}
