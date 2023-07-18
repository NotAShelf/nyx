<h1 id="readme" align="center">
  <img src="https://camo.githubusercontent.com/8c73ac68e6db84a5c58eef328946ba571a92829b3baaa155b7ca5b3521388cc9/68747470733a2f2f692e696d6775722e636f6d2f367146436c41312e706e67" width="100px" /> <br>
  
  NotAShelf's NixOS Configuration Flake <br>

<img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/palette/macchiato.png" width="600px" /> <br>

  <div align="center">

  <div align="center">
   <p></p>
   <a href="">
      <img src="https://img.shields.io/github/issues/notashelf/nyx?color=fab387&labelColor=303446&style=for-the-badge">
   </a>
   <a href="https://github.com/notashelf/nyx/stargazers">
      <img src="https://img.shields.io/github/stars/notashelf/nyx?color=ca9ee6&labelColor=303446&style=for-the-badge">
   </a>
   <a href="https://github.com/notashelf/nyx/">
      <img src="https://img.shields.io/github/repo-size/notashelf/nyx?color=ea999c&labelColor=303446&style=for-the-badge">
   </a>
   <a href="https://github.com/notashelf/nyx/blob/main/LICENSE">
    <img src="https://img.shields.io/static/v1.svg?style=for-the-badge&label=License&message=GPL-3&logoColor=ca9ee6&colorA=313244&colorB=cba6f7"/>
   </a>
   <a href="https://liberapay.com/notashelf/donate"><img src="https://img.shields.io/liberapay/patrons/notashelf.svg?logo=liberapay?color=e5c890&labelColor=303446&style=for-the-badge"></a>
   <br>
</div>
</h1>

<p align="center">
   <img src=".github/assets/desktop_preview.png" width="640" alt="Desktop Preview" />
</p>

## 📦 Overview

### Notable Features

- **Shared Configurations** - Reduces re-used boilerplate code by sharing modules and profiles across hosts.
- **Fully Modular** - Utilizes NixOS' module system to avoid hardcoding any of the options.
- **Profiles** - Provides serialized configuration sets for easily changing large portions of configurations with less options.
- **Sane Defaults** - The modules attempt to bring the most sane defaults, while providing overrides.
- **Secrets Management** - Manage secrets through Agenix.
- **Flexible Modules** - Both Home-manager and NixOS modules allow users to retrieve NixOS or home-manager configurations from anywhere.
- **Extensive Configuration** - Most desktop programs are configured out of the box and shared across hosts, with override options for per-host controls.
- **Wayland First** - Leaves Xorg in the past where it belongs. Everything is configured around Wayland, with Xorg only as a fallback.
- **Opt-in Impermanence** - On-demand ephemeral root using BTRFS rollbacks and Impermanence
- **Encryption Ready** - Supports and actively utilizes full disk encryption.
- **Declarative Themes** - Using [profiles](profiles), `nix-colors` and `wallpkgs`, everything theming is handled inside the flake.
- **Modularized Flake Design** - With the help of [flake-parts](https://flake.parts), the flake has been modularized.
- **Tree-wide formatting** - Format files in any language with the help of devshells and treefmt-nix.

### Layout

- [flake](flake.nix) Ground zero of my system configuration
- [lib](lib) 📚 Personal library of functions and utilities
- [parts](parts) ❄️ Individual parts of my flake, powered by flake-parts
  - [pkgs](pkgs) 📦 Packages exported by my flake
- [docs](docs)📑 The documentation for my flake repository
  - [notes](docs/notes)📝 Notes from tedious or/and underdocumented processes I have gone through
- [homes](home) 🏠 my personalized [Home-Manager](https://github.com/nix-community/home-manager) module
- [modules](modules) 🍱 modularized NixOS configurations
  - [common](modules/common) ⚙️T The common modules imported by all hosts
    - [core](modules/shared) 🧠 Core NixOS configuration
    - [options](modules/options) 🔧 Module options consumed by the rest of the flake
    - [system](modules/system) 💡 A self-made NixOS configuration to dictate system specs
  - [extra](modules/extra) 🚀 Extra modules that are rarely imported
    - [server](modules/extra) ☁️ Shared modules for "server" purpose hosts
    - [desktop](modules/desktop) 🖥️ Shared modules for "desktop" purpose hosts
    - [virtualization](modules/virtualization) 🪛 Hot-pluggable virtualization module for any host
    - [hardware](modules/hardware) Home-baked modules for hardware compatibility
    - [shared](modules/shared) ☁️ Modules that can be consumed by external flakes
    - [export](modules/export) 📦 Modules that are strictly for outside consumption and are not imported by the flake itself
- [hosts](hosts) 🌳 per-host configurations that contain machine specific configurations
  - [enyo](hosts/enyo) 🖥️ My desktop computer boasting a full AMD system. Daily workstation.
  - [prometheus](hosts/prometheus) 💻 My HP Pavillion with a a GTX 1050 and i7-7700hq
    - [epimetheus](hosts/epimetheus) 💻 The succeeding brother host to Prometheus, with full disk encryption
  - [hermes](hosts/hermes) 💻 HP Pavillion with Ryzen 7 7730U, has now replaced Epimetheus as my portable workstation
  - [helios](hosts/helios) ⚡ Hetzner VPS for self-hosting some of my infrastructure
  - [atlas](hosts/atlas) 🍓 Proof of concept server host that is used by my Raspberry Pi 400
  - [icarus](hosts/icarus) 💻 My 2014 Lenovo Yoga Ideapad that acts as a portable server and workstation
  - [erebus](hosts/erebus) 🍱 Air-gapped virtual machine/live-iso configuration for sensitive jobs
  - [gaea](hosts/gaea) 🌱 Custom iso build to precede all creation
  - [artemis](hosts/artemis) 🏹 x86_64-linux VM Host for testing
  - [apollon](hosts/apollon) ⚔️a aarch64-linux VM Host for testing

## Notes

### Preface

If my configuration appears confusing to you, that is because it is confusing.
Admitably, I am not yet very well versed in NixOS or the Nix expression language.
Thus, my configuration is severely limited by my knowledge, despite what my work may
suggest. While I may not be able to follow best Nix practices, I try to follow a particular
logic while organizing this configuration. I also attempt to document everything as
I humanly can.

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

### Disclaimer

> I am not a NixOS _expert_. I am a NixOS _user_.

You _probably_ do not want to copy or base your config off of this repository. It is simply my NixOS configuration, built
around my personal use cases and interests, containing many abstractions that you will need to figure out.
If you do have a question, do feel free to ask and I will do my absolute best to answer them as the circumstances (mainly my own knowledge) allow,
however, do not expect "support" and definitely do not assume this configuration to be following best practices.

Do dissect the configurations all you want, take what you need and if you find yourself to
be excelling somewhere I lack, do feel free to contribute to my atrocities against
NixOS and everything it stands for. Would be appreciated.

_Styling PRs will be rejected because I like my Alejandra, thanks but no thanks._

## Donate

Want to support me, or to show gratitude for something (somewhat) nice I did?
Perhaps consider donating!

<div align="center">

<a href="https://liberapay.com/notashelf/donate">
   <img alt="Donate using Liberapay" src="https://liberapay.com/assets/widgets/donate.svg">
</a>

<a href="https://ko-fi.com/notashelf">
   <img src="https://ko-fi.com/img/githubbutton_sm.svg" alt="Support me on kofi" /> 
</a>

</div>

## Credits & Special Thanks to

### System Configurations

> I ~~shamelessly stole from~~ got inspired by those folks

[sioodmy](https://github.com/sioodmy) -
[rxyhn](https://github.com/rxyhn) -
[fufexan](https://github.com/fufexan) -
[hlissner](https://github.com/hlissner) -
[fortuneteller2k](https://github.com/fortuneteller2k) -
[NobbZ](https://github.com/NobbZ/nixos-config) -
[ViperML](https://github.com/viperML/dotfiles) -
[spikespaz](https://github.com/spikespaz/dotfiles)

... and many more

### Anti-credits

> Pretend I haven't credited those people (but I will, because they are equally awesome)

[n3oney](https://github.com/n3oney)

### Other Cool Resources

> Resource that helped shape and improve this configuation, or resources that I strongly recommend that you read.

- [Vinícius Müller's Blog](https://viniciusmuller.github.io/blog)
- [A list of Nix library functions and builtins](https://teu5us.github.io/nix-lib.html)
- [Viper's Blog](https://ayats.org/)

> Software that helped this configuration become what it is, or software I find interesting

- [Agenix](https://github.com/ryantm/agenix)
- [Hyprland](https://github.com/hyprwm/Hyprland)
- [Neovim-flake](https://github.com/notashelf/neovim-flake)
- [Docr](https://github.com/notashelf/docr)
- [Nh](https://github.com/viperML/ng)

Additionally, take a look at my [notes](docs/notes) for my notes on specific processes on NixOS.

## License

This repository (except for [docs](docs)) is licensed under the [GPL-3.0](LICENSE) license.
The notes and documentation available in [docs](docs) is licensed under the [CC BY License](docs/LICENSE).

If you are directly copying a section of my config, please include a copyright notice at the top of the file. It is not enforced, but would be appreciated.

---

<div align="right">
  <a href="#readme">Back to the Top</a>
</div>
