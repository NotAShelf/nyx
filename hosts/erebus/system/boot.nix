{pkgs, ...}: let
  inherit (pkgs) linuxPackagesFor linuxKernel;
in {
  boot = {
    tmp.cleanOnBoot = true;
    kernel.sysctl = {"kernel.unprivileged_bpf_disabled" = 1;};

    # Always copytoram so that if the image is booted from, e.g., a
    # USB stick, nothing is mistakenly written to persistent storage.
    kernelParams = ["copytoram"];

    # Use latest Linux kernel package
    kernelPackages = linuxPackagesFor linuxKernel.kernels.linux_hardened;
  };
}
