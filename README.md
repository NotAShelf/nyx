<h1 align="center">
  <img src="https://raw.githubusercontent.com/NixOS/nixos-artwork/master/logo/nix-snowflake.svg" width="96px" height="96px" />
  <br>
  Nýx
</h1>

<p align="center">
   My overengineered NixOS flake: Desktops, laptops, servers and everything
   else that can run an OS. Monorepo for everything NixOS.<br/>
</p>

## Philosophy

This repository, as noted before, is a monorepo that contains **all** of my NixOS
setups. That entails desktops, laptops, servers, virtual machines, hobby boards
and eventually mobile phones all running NixOS.

My aim for this repository is to create a central flake that is capable of providing
flexible and sane defaults to hosts of a wide variety, as noted above. The implications
of such a setup inclined me to build a nested module system, which sits on top of nixpkgs'
module system, and allows systems to advertise their own capabilities, further contributing
to my first goal of modularity. Using the said module system allows me to provide defaults
that may change based on the host's own capabilities. My second goal is what NixOS is missing
on fundemental level: documentation. I avoid disregarding unused code, instead opting to
disable modules or commenting out unused code alongside appropriate documentation. If you
are here for a configuration reference, you are highly likely to find most everyday programs
with my personal configurations. See the high level overview below for details on file
and module locations.

As a final note, I would like to point you towards the [credits](#credits) section below
where I pay tribute to the individuals who have contributed to this project, whether through
code reference, suggestions, bug reports, or simply moral support.

## High Level Overview

A high level overview of this monorepo, containing configurations for **all** of my machines
that are running or have ran NixOS at some point in time. My active desktop configuration
can be previewed below, in the [preview](#preview) section.

### Notable Features

[module options]: ./modules/options/style
[profiles]: ./modules/profiles
[wallpkgs]: https://github.com/notashelf/wallpkgs
[flake-parts]: https://flake.parts

- **All-in-one** - Servers, desktops, laptops, virtual machines and anything you can think of.
  Managed in one place.
  - **Sane Defaults** - The modules attempt to bring the most sane defaults, while providing
    per-host toggles for conflicting choices.
  - **Flexible Modules** - Both Home-manager and NixOS modules allow users to retrieve NixOS
    or home-manager configurations from anywhere.
  - **Extensive Configuration** - Most desktop programs are configured out of the box and shared
    across hosts, with override options for per-host controls.
  - **Custom extended library** - An extended library for functions that help organize my system.
- **Shared Configurations** - Reduces re-used boilerplate code by sharing modules and profiles
  across hosts.
- **Fully Modular** - Utilizes NixOS' module system to avoid hardcoding any of the options.
  - **Profiles & Roles** - Provide serialized configuration sets for easily changing large
    portions of configurations with less options and minimal imports.
  - **Detached Homes** - Home-manager configurations are able to be detached for non-NixOS usage
  - **Modularized Flake Design** - With the help of [flake-parts], the flake is fully modular:
    keeping my `flake.nix` cleaner than ever.
  - **Declarative Themes** - Using my [module options], [profiles] and [wallpkgs], everything
    theming is handled inside the flake.
  - **Tree-wide formatting** - Format files in any language with the help of devshells and
    treefmt-nix modules for flake-parts.
- **Personal Installation Media** - Personalized ISO images for system installation and recovery.
- **Secrets Management** - Manage secrets through Agenix.
- **Opt-in Impermanence** - On-demand ephemeral root using BTRFS rollbacks and Impermanence.
- **Encryption Ready** - Supports and actively utilizes full disk encryption.
- **Wayland First** - Leaves Xorg in the past where it belongs. Everything is configured around
  Wayland, with Xorg only as a fallback.

### Repo Structure

[flake schemas]: https://determinate.systems/posts/flake-schemas
[Home-Manager]: https://github.com/nix-community/home-manager

- [flake.nix](./flake.nix) Ground zero of my system configuration. Declaring entrypoints
- [lib](./lib) Personal library of functions and utilities
- [docs](./docs)The documentation for my flake repository
  - [notes](./docs/notes) Notes from tedious or/and under-documented processes I have gone through. More or less a blog
  - [cheatsheet](./docs/cheatsheet.md) Useful tips that are hard to memorize, but easy to write down
- [flake/](./flake) Individual parts of my flake, powered by flake-parts
  - [modules](./flake/modules) modules provided by my flake for both internal and public use
  - [pkgs](./flake/pkgs) packages exported by my flake
  - [schemes](./flake/schemes) home-baked flake schemas for upcoming [flake schemas]
  - [templates](./flake/templates) templates for initializing flakes. Provides some language-specific flakes
  - [args.nix](./flake/args.nix) initiate and configure nixpkgs locally
  - [deployments.nix](./flake/deployments.nix) host setup for deploy-rs, currently a work in progress
  - [treefmt.nix](./flake/treefmt.nix) various language-specific configurations for treefmt
- [homes](./homes) my personalized [Home-Manager] configuration module
- [hosts](./hosts) per-host configurations that contain machine specific instructions and setups
- [modules](./modules) modularized NixOS configurations
  - [core](./modules/common) The core module that all systems depend on
    - [common](./modules/common) Module configurations shared between all hosts (except installers)
    - [profiles](./modules/profiles) Internal module system overrides based on host declarations
    - [roles](./modules/roles) A profile-like system that work through imports and ship predefined configurations
  - [extra](./modules/extra) Extra modules that are rarely imported
    - [shared](./modules/extra/shared) Modules that are both shared for outside consumption, and imported by the flake itself
    - [exported](./modules/extra/exported) Modules that are strictly for outside consumption and are not imported by the flake itself
  - [options](./modules/options) Definitions of module options used by common modules
    - [meta](./modules/options/meta) Internal, read-only module that defines host capabilities based on other options
    - [device](./modules/options/device) Hardware capabilities of the host
    - [documentation](./modules/options/docs) Local module system documentation
    - [system](./modules/options/system) OS-wide configurations for generic software and firmware on system level
    - [theme](./modules/options/theme) Active theme configurations ranging from QT theme to shell colors
    - [usrEnv](./modules/options/usrEnv) userspace exclusive configurations. E.g. lockscreen or package sets
- [secrets](./secrets) Agenix secrets

## Credits & Special Thanks to

[atrocious abstractions]: ./lib/builders.nix

My special thanks go to [fufexan](https://github.com/fufexan) for
convincing me to use NixOS and sticking around to answer my most
stupid and deranged questions, as well as my [atrocious abstractions].

And to [sioodmy](https://github.com/sioodmy) which my configuration is initially based on. The
simplicity of his configuration flake allowed me to take a foothold in the Nix world.

### Anti-credits

Pretend I haven't credited those people (but I will, because they are equally awesome and I appreciate them)

[n3oney](https://github.com/n3oney) -
[gerg-l (bald frog)](https://github.com/gerg-l) -
[eclairevoyant](https://github.com/eclairevoyant/) -
[FrothyMarrow](https://github.com/frothymarrow)

### Awesome People

I ~~shamelessly stole from~~ got inspired by those folks

[sioodmy](https://github.com/sioodmy) -
[fufexan](https://github.com/fufexan) -
[rxyhn](https://github.com/rxyhn) -
[NobbZ](https://github.com/NobbZ) -
[ViperML](https://github.com/viperML) -
[spikespaz](https://github.com/spikespaz) -
[hlissner](https://github.com/hlissner) -
[fortuneteller2k](https://github.com/fortuneteller2k) -
[Max Headroom](https://github.com/max-privatevoid)

... and surely there are more, but I tend to forget.

### Other Cool Resources

Resource that helped shape and improve this configuration, or resources that I strongly recommend that you read.

- [A list of Nix library functions and builtins](https://teu5us.github.io/nix-lib.html)
- [Vinícius Müller's Blog](https://viniciusmuller.github.io/blog)
- [Viper's Blog](https://ayats.org/)
- [Solène's Blog](https://dataswamp.org/~solene)
- [...my own "blog"?](https://notashelf.github.io/nyx/)

Software that helped this configuration become what it is, or software I find interesting

- [Agenix](https://github.com/ryantm/agenix)
- [Hyprland](https://github.com/hyprwm/Hyprland)
- [nh](https://github.com/viperML/nh)
- [ags](https://github.com/aylur/ags)

Projects I have made to use in this repository, or otherwise cool software that are
used in this repository that I would like to endorse.

- [nyxpkgs](https://github.com/notashelf/nyxpkgs) - my personal package collection
- [neovim-flake](https://github.com/notashelf/neovim-flake) - highly modular neovim module for NixOS & Home-manager
- [docr](https://github.com/notashelf/docr) - my barebones static site generator, used to generate my blog
- [schizofox](https://github.com/schizofox/schizofox) - hardened Firefox configuration for the delusional and the paranoid
- [arRPC flake](https://github.com/notashelf/arrpc-flake)

Additionally, take a look at my [notes/blog](./docs/notes) for my notes on specific processes on NixOS.

## License

This repository (except for [anything in docs directory](docs)) is licensed under the [GPL-3.0](./LICENSE) license.
The notes and documentation available in [docs directory](docs) is licensed under the [CC BY License](./docs/LICENSE).

If you are directly copying a section of my config, please include a copyright notice at the top of the file.
It is not enforced, but would be appreciated.

---

<h2 align="center">Preview</h2>

<p id="preview" align="center">
   <img src=".github/assets/desktop_preview.png" width="640" alt="Desktop Preview" /> 
</p>
<p align="center">
   Screenshot last updated <b>2023-12-09</b>
</p>

<div align="right">
  <a href="#readme">Back to the Top</a>
</div>
