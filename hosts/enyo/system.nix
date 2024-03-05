{self, ...}: {
  system = {
    stateVersion = "23.05";
    configurationRevision = self.rev or "dirty";
  };
}
