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

  version = "6.9.1";
  suffix = "xanmod1";
  modDirVersion = "${version}-${suffix}";

  xanmod_custom = linuxKernel.kernels.linux_xanmod_latest.override {
    inherit version suffix modDirVersion;

    # https://github.com/xanmod/linux
    src = fetchFromGitHub {
      owner = "xanmod";
      repo = "linux";
      rev = "refs/tags/${version}-xanmod1";
      hash = "sha256-ZX7Ys83vuh1X+iu73aM4ro73EcIs1+A42ztDXDz3kjI=";
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

      LOCALVERSION = freeform "-shelf";

      CONFIG_LOCALVERSION = freeform "-shelf";
      CONFIG_LOCALVERSION_AUTO = yes;
      CONFIG_DEFAULT_HOSTNAME = freeform "${hostname}";

      GCC_PLUGINS = yes;
      BUG_ON_DATA_CORRUPTION = yes;
    };

    argsOverride = {
      # FIXME: why is this not working, exactly?
      # from what I can tell there is a hook that compares a source string
      # with this value, but I can't figure out which hook does it
      modDirVersion = lib.versions.pad 3 "${version}-shelf";
    };
  };
in {
  inherit xanmod_custom;
}
