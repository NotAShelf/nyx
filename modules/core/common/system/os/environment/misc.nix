{pkgs, ...}: {
  environment = {
    # Disable the stub ELF loader added in 24.05 that serves no purpose other than
    # to throw a warning when you try to run a program that requires dynamic loading.
    # Disable this since I'm already aware of the implications of NixOS on dynamic
    # loading, this is exclusively a fallback for morons.
    stub-ld.enable = false;

    # Enable system-wide wordlist. Some Pandoc filters and other programs
    # depend on wordlist available in system path, and shells do not work.
    # I don't like this, but it's a necessary evil.
    wordlist = {
      enable = true;
      lists.WORDLIST = ["${pkgs.scowl}/share/dict/words.txt"];
    };
  };
}
