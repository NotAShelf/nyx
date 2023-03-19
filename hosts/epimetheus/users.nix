_: {
  users.users = {
    root = {
      # passwordFile needs to be in a volume marked with `neededForBoot = true`
      passwordFile = "/persist/passwords/root";
    };
    notashelf = {
      passwordFile = "/persist/passwords/notashelf";
    };
  };
}
