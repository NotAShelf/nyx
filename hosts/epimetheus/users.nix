_: {
  users = {
    # this option makes it that users are not mutable outside our configurations
    # if you are on nixos, you are probably smart enough to not try and edit users
    # manually outside your configuration.nix or whatever
    mutableUsers = false; # TODO: find a way to handle passwords properly

    # P.S: This option requires you to define a password file for your users
    # inside your configuration.nix - you can generate this password with
    # mkpasswd -m sha-512 > /persist/passwords/notashelf after you confirm /persist/passwords exists

    users = {
      root = {
        # passwordFile needs to be in a volume marked with `neededForBoot = true`
        passwordFile = "/persist/passwords/root";
      };
      notashelf = {
        passwordFile = "/persist/passwords/notashelf";
      };
    };
  };
}
