{
  imports = [
    # PipeWire sound server
    # the primary server for most of my systems
    ./pipewire

    # kept for backwards compatibility
    ./pulse.nix
  ];
}
