# Signing Git commits with SSH keys

## Resources

- https://blog.gitbutler.com/git-tips-and-tricks/

## Setting up SSH signing for Git commits

For the longest of times, I have been running an obscure GPG setup that requires
me to go back to my notes every time I wish to replicate it on a new machine or
a friend's machine to help them set up GPG signing on their system. Today, after
roughly 6 years of pushing GPG signed commits, I have learned about SSH
signing[^1], and have decided to share my notes on setting it up.

> A basic prerequisite is that you need your SSH key pair added to the Git
> service you will be using e.g., Github or Forgejo, so that you are able to
> push and pull via SSH. The
> [Github Documentation](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)
> shows you how to set that up, and I imagine other platforms are not that more
> complicated.

### Traditional Distros

If you are using a traditional distribution like Fedora or Arch[^2] then the
setup consists of two commands:

```bash
git config --global gpg.format ssh # tell Git to use SSH signing keys
```

Followed by the command to tell Git which key to use:

```bash
git config --global user.signingkey ~/.ssh/my-key.pub
```

If you wish to sign commits of a specific repository, then you may run the above
command in said repository and omit `--global` to store the local (repository)
configuration in `.git/` directory of the repository you can the command in.

> Remember to replace the example path I've used above with the path to your
> **public** key.

Now it is time to tell Github about your signing key. Add your public key to
Github again, but this time change the key type to "Signing Key". The process
should once again be similar for other public Git services.

Last, you will want to actually use the signing key that you have configured Git
to use for _signed_ commits. That's right, all commits are unsigned until you
either pass `-S` to `git commit` or set
`git config --global commit.gpgsign true`. Similarly, you can also sign selected
tags with `git tag -s`. To sign _all_ git tags, you must run
`git config --global tag.gpgsign true`, or the same command without `--global`
to sign tags in a local repository.

### On NixOS

In typical NixOS fashion, such a trivial process is mind-numbingly easy. You
will want to configure `programs.git` under either NixOS or Home-Manager module
systems. As Git is rather a userspace application, I choose to use the one under
home-manager but NixOS also allows you to configure git globally with
`/etc/gitconfig` being used.

First you would like to add `programs.git.signing` to your home.nix as follows:

```nix
# home.nix
programs.git = {
  signing = {
    key = "${config.home.homeDirectory}/.ssh/my-key.pub";
    signByDefault = true;
  };

  extraConfig.gpg.format = "ssh";
};
```

and this will be enough to tell Git where to look while also setting
`signByDefault`, meaning all of your commits will be signed. Great!

If you wish to take this a bit further, you may consider setting allowed signers
to decide who can and cannot sign using the `ssh.allowedSignersFile` option
under `extraConfig.gpg`. Do keep in mind, however, that you need to have set an
allowed signers file beforehand. To do so, expand your `home.nix` with the new
options:

```nix
# home.nix
{config, pkgs, ...}: let
  key = "<your public key>";
  email = "<your email>";

  # Write signersFile to /nix/store/<store path>
  signersFile = pkgs.writeText "git-allowed-signers" ''
    ${email} namespaces="git" ${key}
  '';
in {
  xdg.configFile."git/allowed_signers".text = signersFile;

  programs.git = {
    signing = {
      key = "${config.home.homeDirectory}/.ssh/my-key.pub";
      signByDefault = true;
    };

    extraConfig.gpg = {
      format = "ssh";
      ssh.allowedSignersFile = signersFile;
    };
  };
};
```

In above example, we have written a symlink to `~/.config/git/allowed_signers`
using `xdg.configFile` and `pkgs.writeText`. Then,
`programs.git.extraConfig.gpg.ssh.allowedSignersFile` tells Git which users will
be allowed to sign commits based on commit email.

And that is all! You may now switch Home-Manager generations with either
`nixos-rebuild switch` (if you have Home-Manager as a NixOS module) or
`home-manager switch` (if you are using home-manager in standalone mode). Do
make sure to adapt the example to your own setup.

[^1]:
    To be fair, I have known about SSH signing for a while now, but the
    sunk-cost fallacy has prevented me from ever looking into it. I am still not
    convinced by it, but that is because I still use a Yubikey based GPG setup.

[^2]: Please don't.
