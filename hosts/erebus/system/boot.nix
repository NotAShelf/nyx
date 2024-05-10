{
  # Always copytoram so that, if the image is booted from, e.g., a
  # USB stick, nothing is mistakenly written to persistent storage.
  boot = {
    kernelParams = ["copytoram"];
    tmp.cleanOnBoot = true;
    kernel.sysctl = {"kernel.unprivileged_bpf_disabled" = 1;};
  };
}
