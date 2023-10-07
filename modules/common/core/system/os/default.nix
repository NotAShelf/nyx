_: {
  imports = [
    ./environment # environment configuration
    ./programs # general programs
    ./services # gemeral services
    ./users # per user configurations
    ./display # display protocol (wayland/xorg)
    ./network # network configuration & tcp optimizations
  ];
}
