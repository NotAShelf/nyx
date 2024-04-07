{
  lib,
  fetchFromGitHub,
  linuxKernel,
  hostname ? "",
  ...
}: let
  inherit (lib.kernel) yes no freeform;
  inherit (lib.attrsets) mapAttrs;
  inherit (lib.modules) mkForce;

  version = "6.8.4";
  suffix = "xanmod1";
  modDirVersion = "${version}-${suffix}";

  xanmod_custom = linuxKernel.kernels.linux_xanmod_latest.override {
    inherit version suffix modDirVersion;

    # https://github.com/xanmod/linux
    src = fetchFromGitHub {
      owner = "xanmod";
      repo = "linux";
      rev = "refs/tags/${version}-xanmod1";
      hash = "sha256-NQeUz50aBRvbHqhoOGv5CFQKKlKeCUEkCA8uf9W0f0k=";
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

      CONFIG_LOCALVERSION = freeform "-${suffix}";
      CONFIG_LOCALVERSION_AUTO = yes;
      CONFIG_DEFAULT_HOSTNAME = freeform "${hostname}";
    };
  };
in {
  inherit xanmod_custom;
}
