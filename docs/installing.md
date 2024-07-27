# Installing

[resources]: https://github.com/notAShelf/nyx?tab=readme-ov-file#cool-resources
[interactive pages]: https://github.com/notAShelf/nyx?tab=readme-ov-file#interactive-pages
[NixOS manual]: https://nixos.org/manual/nixos/stable
[Nixpkgs manual]: https://nixos.org/manual/nixpkgs/stable/
[@viperML's blog]: https://ayats.org/

Sorry, but I do not provide installation steps for any of my configurations! I
will recommend, however, a bunch of helpful [resources] to begin with.

<!-- deno-fmt-ignore-start -->

> [!TIP]
> The [NixOS manual] should be your holy book at all times. [Nixpkgs manual]
> will answer your questions on concepts you will become familiar down the line.
> Additionally, [@viperML's blog] can shed some light on workflows with Nix and
> [interactive pages] will allow you to search obscure library functions,
> options or packages.

<!-- deno-fmt-ignore-end -->

I do not provide any installation tips for _this_ repo, but here are my tips to
any beginner that may be looking into starting with NixOS. If you are a hardened
veteran, you might still benefit from checking out the [resources] section for
some lesser-known tips that are only documented in blogs. You learn something
new every day :)

## Personal Tips

[learnxinyminutes.com]: https://learnxinyminutes.com/docs/nix
[noogle.dev]: https://noogle.dev
[module system]: https://nixos.org/manual/nixos/stable/#sec-writing-modules
[search.nixos.org]: https://search.nixos.org
[stop-using-nix-env.privatevoid.net]: https://stop-using-nix-env.privatevoid.net/
[Archwiki]: https://wiki.archlinux.org/
[Gentoo Wiki]: https://wiki.gentoo.org

0. **Do not attempt to boot off this configuration**. Really, you will not have
   a good time. There are much better things you can spend your time on,
   learning Nix being only one of them.

   - Likewise, dissecting other NixOS users' configurations is _not_ a good idea
     until you are comfortable with Nix: you _will_ be confused by the sheer
     number of abstractions and hacks one might feel is adequate when it really
     is not.

1. **Evaluate your choice of distro accordingly**. Nix and NixOS come with a
   very specific set of pros and cons: you will need to carefully consider
   whether you are willing to make the trade.

   - Nix and NixOS will make assumptions about your knowledge about traditional
     concepts that NixOS build upon. A degree of familiarity is expected.
   - Generic distributed binaries will not work, and will likely need specific
     building or patching steps to make sure the program works on NixOS. You
     will need to get familiar with the packaging. Ask yourself if you _really_
     wish to spend your time learning a brand new ecosystem. There are (usually)
     no shortcuts to take.
   - Form your own opinion. I have witnessed a large number of NixOS user making
     the switch because someone who they hold in high regard has told them to.
     Do not make the switch unless you are confident you _truly_ understand the
     pros and cons of the system. An immutable, declarative, "infrastructure as
     code" system may sound cool but it could also be truly redundant if you are
     not planning to make use of its blessings. What good are atomic rollbacks
     for if you get everything from Flatpak repositories?

2. **Use the minimal installer**. Calamares in nixpkgs contains nasty hacks and
   limitations that can severely cripple your installation, or create obscure
   issues. Use the minimal installer to familiarize yourself with the ecosystem,
   and you will have a smoother experience.

   - You may still get the _graphical_ ISO if you prefer to boot from a
     graphical environment. It will contain the command-line tools you can use
     to install NixOS manually, but make sure to **avoid Calamares** regardless
     of your installer ISO.

3. **Try one thing at a time**. Nix and NixOS will throw at you a wide variety
   of concepts that you will need to learn. Some of those concepts are optional,
   some are mandatory and others are good to know. The variety can be
   overwhelming, so learn about the Nix language first to help you learn
   concepts that you will come by later. [learnxinyminutes.com] has a pretty
   sweet page on learning data types in Nix. You will need to know about those.

   - Learn about the custom library. nixpkgs contains its own standard library,
     usually available under `lib` and you will likely need to build your own at
     some point. Check out [noogle.dev] for interactive documentation on
     `builtins` and the standard library (`lib`). It also contains documentation
     on obscure builders in `pkgs` that you might need to use.
   - Leave flakes to later. A lot of Nix users begin under the impression that
     flakes are mandatory - they are not. You do not need to use flakes unless
     you feel comfortable working with them. First understand the NixOS'
     [module system] and I assure you, you will reap its rewards.
   - Ask. NixOS community has been one of the best communities I have been a
     part of. No matter how dumb and obscure my questions may be, I have found
     answers and guidance. While I **will not** provide support for this
     repository, I am happy to answer your questions regarding Nix or NixOS if
     you create an issue under the issues tab. Ask, and ye shall receive.

4. **Source code is the documentation**. NixOS is known for its bad
   documentation and while bad is not the word I would use for it, it is
   certainly disorganized and hard to parse. My recommendation is reading the
   source code - mostly for packages and modules.

   - While the term "source code" may seem daunting, it may not be as difficult
     to navigate as you might anticipate. NixOS modules are _self-documenting_,
     meaning that almost all module options will include a `description` section
     that maintainers use to leave human-readable comments and notes on module
     options. You can browse in [search.nixos.org] will contain useful tips on
     how you may set up certain options.

   - Read the error messages. They are certainly not great, but you would be
     surprised by how much a 5-10 line read gets you. Newer Nix versions have
     also gotten much better at displaying error locations, so this may be a
     non-issue for you.

   - If reading Nix code and derivations still sound difficult, consider that
     Nix _might not_ be for you. There is lots of reading and so little
     hand-holding involved - you will need to adapt.

5. **Use the module system**. I really cannot emphasize this enough: you should
   master the module system. It is your greatest ally while setting up NixOS.

   - First learn to _read_ the module system, then learn to _write_ for it.
     Every option you see in NixOS configurations are provided by the module
     system. For example, `programs.firefox.enable` or
     `services.miniflux.enable` are program and service setups provided by
     Nixpkgs' module system. Generally both of those options handle adding the
     package for the program in question to your package list _in addition_ to
     providing an interface for configuring the program.

   - Sometimes programs will require additional setup, setup that you would not
     get automatically by simply adding the package to
     `environment.systemPackages` or `home.packages`. The module system also
     provides a remedy to this by automating the setup process (and still adding
     the package to your respective `packages` list.) When you see an option
     such as `programs.foo.enable`, choose it over adding `foo` to your system
     packages.

6. **Avoid nix-env if you can help it**. Ad-hoc package management is not Nix's
   strong suit, and on NixOS you do not need it. Better, declarative,
   alternatives are at your disposal.

   - Use `environment.systemPackages` for system-wide package installations,
     `users.users.<your_username>.packages` for user-specific package
     installations or `home.packages` for user-specific package installations
     under Home-Manager. See [stop-using-nix-env.privatevoid.net] for more
     details to why, and how.

   - On non-NixOS systems, prefer using the flake-enabled nix3 commands.
     `nix profile install nixpkgs#foo` would be preferable to its nix-env
     counterpart due to design related reasons.

7. **Avoid starter templates**. The aforementioned lack of good documentation
   has lead to many Nix users producing their own starter templates. While I
   cannot say _all_ templates lack quality, I can _confidently_ say that they
   will almost always contain opinionated defaults, defaults that may confuse
   some users.

   - Use the default configuration, and additional utilities (such as flakes,
     Home-Manager, etc.) one by one as you need them. You _may not_ always want
     the default configurations and options shipped by templates.
   - NixOS moves fast, and breaks. If the template you have decided on is old,
     you may come across obscure error messages that just tell you that
     something is removed - but not how to resolve the issue.

8. **Experiment**. You will find that a lot of times, documentation found in
   commonly cited resources such as [Archwiki] or [Gentoo Wiki] apply with
   varying degrees of tweaking involved. Examples on common setups may still be
   possible to ship on NixOS using the aforementioned module system.

   - One of benefits of NixOS is that you have the luxury to experiment: atomic
     rollbacks will allow you to go back from your mistakes when you eventually
     make one. Use this feature, and tweak your system. Though, remember to keep
     backups. No rollback system is _truly_ infallible.

That concludes my list of "starter" tips and tricks. If you happen to have
stumbled upon this page, but remain curious _please_ do contact me. I am willing
to answer your questions as long as I am free over e-mail via
`raf [at] notashelf [dot] dev` or over Discord, by the handle `@notashelf`. You
may also reach out to me over Mastodon, via `@raf@social.notashelf.dev` or on
Matrix, by shooting me a DM at `https://matrix.to/#/@raf:notashelf.dev`

I also welcome your feedback over those channels, should you wish to provide
any.
