<p align="center">
    <img src="https://camo.githubusercontent.com/8c73ac68e6db84a5c58eef328946ba571a92829b3baaa155b7ca5b3521388cc9/68747470733a2f2f692e696d6775722e636f6d2f367146436c41312e706e67" width="96px" height="96px" />
</p>

<h1 align="center">
  Nýx
</h1>

<p align="center">
  An overengineered NixOS flake containing various configurations
</p>

<h2 id="nyx" align="center">
<img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/palette/macchiato.png" width="600px" /> <br>
  <br>
  <div align="center">
    <a href="https://github.com/notashelf/nyx/stargazers">
      <img src="https://img.shields.io/github/stars/notashelf/nyx?color=F5BDE6&labelColor=303446&style=for-the-badge&logo=starship&logoColor=F5BDE6">
    </a>
    <a href="https://github.com/notashelf/nyx/">
      <img src="https://img.shields.io/github/repo-size/notashelf/nyx?color=C6A0F6&labelColor=303446&style=for-the-badge&logo=github&logoColor=C6A0F6">
    </a>
    <a href="https://github.com/notashelf/nyx/blob/main/LICENSE">
      <img src="https://img.shields.io/static/v1.svg?style=for-the-badge&label=License&message=GPL-3&colorA=313244&colorB=F5A97F&logo=unlicense&logoColor=F5A97F&"/>
    </a>
    <a href="https://liberapay.com/notashelf/donate">
      <img src="https://img.shields.io/liberapay/patrons/notashelf.svg?color=e5c890&labelColor=303446&style=for-the-badge&logo=liberapay&logoColor=E5C890"></a>
    <br>
    <a = href="https://nixos.org">
      <img src="https://img.shields.io/badge/NixOS-unstable-blue.svg?style=for-the-badge&labelColor=303446&logo=NixOS&logoColor=white&color=91D7E3">
    </a>
  </div>
</h2>

<p id="preview" align="center">
   <img src=".github/assets/desktop_preview.png" width="640" alt="Desktop Preview" /> 
</p>
<p align="center">
   Screeenshot last updated <b>2023-06-13</b>
</p>

## 📦 Overview

### 📓 Notable Features

- **Shared Configurations** - Reduces re-used boilerplate code by sharing modules and profiles across hosts.
- **Fully Modular** - Utilizes NixOS' module system to avoid hardcoding any of the options.
- **All-in-one** - Servers, desktops, laptops, virtual machines and anything you can think of. Managed in one place.
- **Detached Homes** - Home-manager configurations are able to be detached for non-NixOS usage
- **Profiles** - Provides serialized configuration sets for easily changing large portions of configurations with less options.
- **Sane Defaults** - The modules attempt to bring the most sane defaults, while providing overrides.
- **Secrets Management** - Manage secrets through Agenix.
- **Flexible Modules** - Both Home-manager and NixOS modules allow users to retrieve NixOS or home-manager configurations from anywhere.
- **Extensive Configuration** - Most desktop programs are configured out of the box and shared across hosts, with override options for per-host controls.
- **Wayland First** - Leaves Xorg in the past where it belongs. Everything is configured around Wayland, with Xorg only as a fallback.
- **Opt-in Impermanence** - On-demand ephemeral root using BTRFS rollbacks and Impermanence
- **Encryption Ready** - Supports and actively utilizes full disk encryption.
- **Declarative Themes** - Using my module options, [profiles](profiles), `nix-colors` and `wallpkgs`, everything theming is handled inside the flake.
- **Modularized Flake Design** - With the help of [flake-parts](https://flake.parts), the flake is fully modular.
- **Tree-wide formatting** - Format files in any language with the help of devshells and treefmt-nix.

### 📚 Layout

- [flake.nix](flake.nix) Ground zero of my system configuration
- [lib](lib) 📚 Personal library of functions and utilities
- [secrets](secrets) 🔒 Agenix secrets
- [flake](flake) ❄️ Individual parts of my flake, powered by flake-parts
  - [pkgs](flake/pkgs) 📦 packages exported by my flake
  - [schemes](flake/schemes) 🪡 home-baked flake schemas for upcoming [flake schemas](https://determinate.systems/posts/flake-schemas)
  - [templates](flake/templates) 📖 templates for initializing flakes. Provides some language-specific flakes
- [docs](docs)📑 The documentation for my flake repository
  - [todo](docs/todo) 📝 My to-do notes
  - [notes](docs/notes) 📓 Notes from tedious or/and underdocumented processes I have gone through. More or less a blog
- [homes](home) 🏠 my personalized [Home-Manager](https://github.com/nix-community/home-manager) module
- [modules](modules) 🍱 modularized NixOS configurations
  - [core](modules/common) ⚙️T The core module that all systems depend on
    - [common](modules/shared) 🧠 Module configurations shared between hosts
    - [options](modules/options) 🔧 Definitions for module options used by common modules
    - [types](modules/types) 💡 A profile-like system that is organized per device type
  - [extra](modules/extra) 🚀 Extra modules that are rarely imported
    - [shared](modules/shared) ☁️ Modules that are both shared for outside consumption, and imported by the flake itself
    - [exported](modules/exported) 📦 Modules that are strictly for outside consumption and are not imported by the flake itself
- [hosts](hosts) 🌳 per-host configurations that contain machine specific configurations

## 🗒️ Notes

### Disclaimer

> I am not a NixOS _expert_. I am a NixOS _user_.

You _probably_ do not want to copy or base your config off of this repository. It is simply _my_ NixOS configuration, built
around my personal use cases and interests, containing many abstractions that you will need to figure out. If you do have a question, do feel free to ask
and I will do my absolute best to answer them as the circumstances (mainly my own knowledge) allow, however, do not expect "support"
and definitely do not assume this configuration to be following best practices that should be taken as-is.

Do dissect the configurations all you want, take what you need and if you find yourself to
be excelling somewhere I lack, do feel free to contribute to my atrocities against
NixOS and everything it stands for. Would be appreciated.

### Preface

If my configuration appears confusing to you, that is because it _is_ confusing
to anyone who is not me. These are _my_ configurations and naturally, they are designed
within my sense of what is "logical". Which means it will not make much sense to you.
If it does, that is great. You may perhaps "audit" my configuration and provide me with suggestions.
If it does not, well, that is unfortunate, however, you are welcome to ask me when you get stuck.

The resulting configuration was based off of _many_ others which I have linked below.
If you like anything about this particular repository, you will probaby be interested
in checking them out. If you like what _I_ have been doing and if it's helpful to you
in any shape or form, consider leaving a star or donating to me (every bit would be appreciated)
from the links below. Up to you.

If you have anything to say or ask about those conigurations (especially if it was because
you were absolutely horrified by my atrocities against Nix or NixOS) I invite you to
create an issue on open a pull request. I am always happy to learn and improve.
Some of my mental notes (hopefully to be organized better when I finish my blog)
can be found in [my notes directory](../docs/notes). Should you need explanation on
some of the things I've done, or might do me the favor of proofreading my notes, you may take a look in there.

### Motivation

I often switch devices, due to a myriad of reasons, and regardless of the reason,
I would like to be able to get my new devices up and running in minutes without having to move
a bunch of files and various configurations from one device to another.
Thanks to the declarative nature of NixOS, not only
can I install my previous system to a new host almost entirely identically, I can also bootstrap
a new host for a new machine in minutes with my personal abstractions.

Which is exactly why I have converted all my devices to NixOS. While I do have much to learn
the NixOS ecosystem is an incredible learning opportunity and a good practice for
those who want to switch inbetween devices at ease, or have common "mixin"
configs that are shared between multiple devices. All things considered, it is
an excellent idea to learn Nix (the programming language) and NixOS.

If you are here for my "legacy" Arch Linux dotfiles, you can find them [in here](https://github.com/NotAShelf/dotfiles).

## Credits & Special Thanks to

### Awesome People

My special thanks go to [fufexan](https://github.com/fufexan) for convincing me to use NixOS
and sticking around to answer my most stupid and derangedd questions, as well as my atrocious
abstractions.

And to [sioodmy](https://github.com/sioodmy) which my configuration is initially based on. The
simplicity of his configuration flake allowed me to take a foothold in the Nix world.

### System Configurations

> I ~~shamelessly stole from~~ got inspired by those folks

[sioodmy](https://github.com/sioodmy) -
[rxyhn](https://github.com/rxyhn) -
[fufexan](https://github.com/fufexan) -
[hlissner](https://github.com/hlissner) -
[fortuneteller2k](https://github.com/fortuneteller2k) -
[NobbZ](https://github.com/NobbZ/nixos-config) -
[ViperML](https://github.com/viperML/dotfiles) -
[spikespaz](https://github.com/spikespaz/dotfiles) -
[privatevoid/depot](https://github.com/privatevoid-net/depot)

... and surely there are more, but I tend to forget.

### Anti-credits

> Pretend I haven't credited those people (but I will, because they are equally awesome)

[n3oney](https://github.com/n3oney) -
[gerg-l (bald frog)](https://github.com/gerg-l)

### Other Cool Resources

> Resource that helped shape and improve this configuation, or resources that I strongly recommend that you read.

- [Vinícius Müller's Blog](https://viniciusmuller.github.io/blog)
- [A list of Nix library functions and builtins](https://teu5us.github.io/nix-lib.html)
- [Viper's Blog](https://ayats.org/)

> Software that helped this configuration become what it is, or software I find interesting

- [Agenix](https://github.com/ryantm/agenix)
- [Hyprland](https://github.com/hyprwm/Hyprland)
- [Nh](https://github.com/viperML/ng)

> Stuff that I make and was designed for/is used in this repository

- [neovim-flake](https://github.com/notashelf/neovim-flake)
- [docr](https://github.com/notashelf/docr)
- [nyxpkgs](https://github.com/notashelf/nyxpkgs)
- [schizofox](https://github.com/schizofox/schizofox)

Additionally, take a look at my [notes](docs/notes) for my notes on specific processes on NixOS.

## 📜 License

This repository (except for [anything in docs directory](docs)) is licensed under the [GPL-3.0](LICENSE) license.
The notes and documentation available in [docs directory](docs) is licensed under the [CC BY License](docs/LICENSE).

If you are directly copying a section of my config, please include a copyright notice at the top of the file.
It is not enforced, but would be appreciated.

---

<div align="right">
  <a href="#readme">Back to the Top</a>
</div>
