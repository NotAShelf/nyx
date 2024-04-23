{
  users = {
    # This is a live environment, and we want it to be as deterministic as possible during
    # its short life. Meaning users should not be able to change their own password from
    # whatever it is defined below this option.
    mutableUsers = false;

    users = {
      root.initialPassword = "";

      nixos = {
        isNormalUser = true;
        uid = 1000;
        initialPassword = "nixos";
        extraGroups = ["wheel"];
      };
    };
  };
}
