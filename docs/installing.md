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
> Additionally, [viperMl's blog] can shed some light on workflows with Nix and
> [interactive pages] will allow you to search obscure library functions,
> options or packages.

<!-- deno-fmt-ignore-end -->

## Personal Tips

[learnxinyminutes.com]: https://learnxinyminutes.com/docs/nix
[noogle.dev]: https://noogle.dev
[module system]: https://nixos.org/manual/nixos/stable/#sec-writing-modules
[search.nixos.org]: https://search.nixos.org
[stop-using-nix-env.privatevoid.net]: https://stop-using-nix-env.privatevoid.net/

1. Do not attempt to boot off this configuration. Really, you will not have a
   good time. There are much better things you can spend your time on, learning
   Nix being only one of them.

2. Use the **minimal** installer. Calamares in nixpkgs contains nasty hacks and
   limitations that can severely cripple your installation, or create obscure
   issues. Use the minimal installer to familiarize yourself with the ecosystem,
   and you will have a smoother experience.

3. Try one thing at a time. NixOS will throw a lot of concepts at you, most of
   which are not optional. Learn about the Nix language first.
   [learnxinyminutes.com] has a pretty sweet page on learning data types in Nix.
   You will need to know about those.

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

4. Source code is the documentation. NixOS is known for its bad documentation
   and while bad is not the word I would use for it, it is certainly
   disorganized and hard to parse. My recommendation is reading the source
   code - mostly for packages and modules.

   - While "source code" may seem daunting, it may not be as difficult to
     navigate as you anticipate. NixOS modules are self-documenting: most module
     options will include a `description` section that maintainers use to leave
     human-readable comments and notes on module options. You can browse in
     [search.nixos.org] will contain useful tips on how you may set up certain
     options.

5. Use the module system. I really cannot emphasize this enough: you should
   master the module system. It is your greatest ally while setting up NixOS.
   Sometimes programs will require additional setup, setup that you would not
   get automatically by simply adding the package to
   `environment.systemPackages` or `home.packages`. The module system also
   provides a remedy to this by automating the setup process (and still adding
   the package to your respective `packages` list.) When you see an option such
   as `programs.foo.enable`, choose it over adding `foo` to your system
   packages.

6. Avoid nix-env if you can help it. Ad-hoc package management is not Nix's
   strong suit, and on NixOS you do not need it. Use
   `environment.systemPackages` for system-wide package installations,
   `users.users.<your_username>.packages` for user-specific package
   installations or `home.packages` for user-specific package installations
   under Home-Manager. See [stop-using-nix-env.privatevoid.net] for more details
   to why, and how.
