{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.kernel) yes no;
  inherit (lib.attrsets) mapAttrs;
  inherit (lib.modules) mkForce;
in {
  modules.system.boot.kernel = let
    version = "6.8.2";
    suffix = "xanmod1";
    modDirVersion = "${version}-${suffix}";
  in
    pkgs.linuxKernel.kernels.linux_xanmod_latest.override {
      inherit version suffix modDirVersion;

      # https://github.com/xanmod/linux
      src = pkgs.fetchFromGitHub {
        owner = "xanmod";
        repo = "linux";
        rev = "refs/tags/${version}-xanmod1";
        hash = "sha256-JddPg/EWJZq5EIemcaULM5c6yLGkfb2E6shxxq37N3M=";
      };

      # poor attempt to make kernel builds use ccache
      stdenv = pkgs.ccacheStdenv;
      buildPackages = pkgs.buildPackages // {stdenv = pkgs.ccacheStdenv;};

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
}
