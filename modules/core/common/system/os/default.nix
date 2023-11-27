{
  imports = [
    ./environment # environment configuration
    ./programs # general programs
    ./services # gemeral services
    ./users # per user configurations
    ./display # display protocol (wayland/xorg)
    ./networking # network configuration & tcp optimizations
    ./fs # filesystem support options
    ./boot # boot and bootloader configurations
    ./misc # things that don't fit anywhere else
  ];
}
