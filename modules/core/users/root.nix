_: {
  users.mutableUsers = false;
  users.users.root = {
    initialPassword = "changeme";

    # passwordFile needs to be in a volume marked with `neededForBoot = true`
    passwordFile = "/persist/passwords/root";
  };
}
