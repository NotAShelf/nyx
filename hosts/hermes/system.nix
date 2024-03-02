{self, ...}: {
  config = {
    boot.kernelParams = [
      "i8042.nomux" # Don't check presence of an active multiplexing controller
      "i8042.nopnp" # Don't use ACPIPn<P / PnPBIOS to discover KBD/AUX controllers
    ];

    system = {
      stateversion = "23.05";
      configurationrevision = self.rev or "dirty";
    };
  };
}
