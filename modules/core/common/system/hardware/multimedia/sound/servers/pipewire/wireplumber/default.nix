{config, ...}: {
  # WirePlumber is a modular session / policy manager for PipeWire
  imports = [
    ./devices.nix
    ./settings.nix
  ];

  config = {
    services.pipewire.wireplumber.enable = config.services.pipewire.enable;
  };
}
