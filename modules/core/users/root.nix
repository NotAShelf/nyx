_: {
  users.users.root = {
    # I am *not* locking myself out of the system again
    # thank you very much.
    initialPassword = "changeme";

    # passwordFile needs to be in a volume marked with `neededForBoot = true`
    passwordFile = "/persist/passwords/root";
  };
}
