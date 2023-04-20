_: {
  programs = {
    # TODO: declarative ssh config
    ssh = {
      enable = true;
      hashKnownHosts = true;
      compression = true;
      matchBlocks = {
        "aur" = {
          hostname = "aur.archlinux.org";
          user = "john";
          identityFile = "~/.ssh/aur";
        };

        "builder" = {
          hostname = "builder.neushore.dev";
          user = "builder";
          identityFile = "~/.ssh/builder";
        };

        "frozendev" = {
          hostname = "builder.neushore.dev";
          user = "raf";
          identityFile = "builder";
        };

        "notavps" = {
          hostname = "notashelf.dev";
          user = "builder";
          identityFile = "builder";
          port = 2214;
        };

        "github" = {
          hostname = "github.com";
          identityFile = "~/.ssh/github_rsa";
        };

        "neushore" = {
          hostname = "ssh.neushore.dev";
          user = "raf";
          identityFile = "~/.ssh/neushore";
        };
      };
    };
  };
}
