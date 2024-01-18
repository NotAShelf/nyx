{
  programs = {
    ssh = {
      enable = true;
      hashKnownHosts = true;
      compression = true;
      matchBlocks = let
        commonIdFile = "~/.ssh/id_ed25519";
      in {
        "aur" = {
          hostname = "aur.archlinux.org";
          identityFile = "~/.ssh/aur";
        };

        "builder" = {
          hostname = "build.neushore.dev";
          user = "builder";
          identityFile = "~/.ssh/builder";
          port = 30;
        };

        "helios" = {
          port = 30;
        };

        "enyo" = {
          port = 30;
        };

        "hermes" = {
          port = 30;
        };

        "epimetheus" = {
          port = 30;
        };

        "icarus" = {
          port = 30;
        };

        "nix-builder" = {
          hostname = "helios";
          user = "nix-builder";
          identityFile = "~/.ssh/builder";
        };

        "frozendev" = {
          hostname = "frzn.dev";
          user = "raf";
          identityFile = "~/.ssh/id_rsa";
        };

        "github" = {
          hostname = "github.com";
          identityFile = "~/.ssh/github_rsa";
        };

        "neushore" = {
          hostname = "ssh.neushore.dev";
          user = "raf";
          identityFile = "~/.ssh/neushore";
          port = 30;
        };
      };
    };
  };
}
