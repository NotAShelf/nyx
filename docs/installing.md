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

1. **Do not attempt to boot off this configuration**. Really, you will not have
   a good time. There are much better things you can spend your time on,
   learning Nix being only one of them.

2. **Use the minimal installer**. Calamares in nixpkgs contains nasty hacks and
   limitations that can severely cripple your installation, or create obscure
   issues. Use the minimal installer to familiarize yourself with the ecosystem,
   and you will have a smoother experience.

3. **Try one thing at a time**. Nix and NixOS will throw at you a wide variety
   of concepts that you will need to learn. Some of those concepts are optional,
   some are mandatory and others are good to know. The variety can be
   overwhelming, so şearn about the Nix language first to help you learn
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
     answers. While I **will not** provide support for this repository, I am
     happy to answer your questions regarding Nix or NixOS if you create an
     issue under the issues tab. Ask, and ye shall receive.

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

5. **Use the module system**. I really cannot emphasize this enough: you should
   master the module system. It is your greatest ally while setting up NixOS.
   Sometimes programs will require additional setup, setup that you would not
   get automatically by simply adding the package to
   `environment.systemPackages` or `home.packages`. The module system also
   provides a remedy to this by automating the setup process (and still adding
   the package to your respective `packages` list.) When you see an option such
   as `programs.foo.enable`, choose it over adding `foo` to your system
   packages.

6. **Avoid nix-env if you can help it**. Ad-hoc package management is not Nix's
   strong suit, and on NixOS you do not need it.

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
   cannot personally confirm _all_ of them lack quality, I can confidently say
   that they will almost always contain opinionated defaults that may confuse
   some users.
   - Use the default configuration, and additional utilities (such as flakes,
     Home-Manager, etc.) one by one as you need them. You _may not_ always want
     the default configurations and options shipped by templates.
   - NixOS moves fast, and breaks. If the template you have decided on is old,
     you may come across obscure error messages that just tell you that
     something is removed - but not how to resolve the issue.

That concludes my list of "starter" tips and tricks. If you happen to have
stumbled upon this page, but remain curious _please_ do contact me. I am willing
to answer your questions as long as I am free over e-mail via
`raf [at] notashelf [dot] dev` or over Discord, by the handle `@notashelf`. You
may also reach out to me over Mastodon, via `@raf@social.notashelf.dev` or on
Matrix, by shooting me a DM at `https://matrix.to/#/@raf:notashelf.dev`
