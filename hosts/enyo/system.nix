{self, ...}: {
  system = {
    stateversion = "23.05";
    configurationrevision = self.rev or "dirty";
  };
}
