<p align="center">
   ⚠️ The `system-module` branch (the one you are currently on) is for the upcoming rework and is not at all stable. See the `nixos` branch
   for the last confirmed stable version of my NixOS configuration
</p>

<h1 align="center">
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
- **Encryption Ready** - Supports and actively utilizes FDE (full disk encryption).
- **Declarative Themes** - Using [profiles](profiles), `nix-colors` and `wallpkgs`, everything theming is handled inside the flake.

### Layout

- [flake](flake.nix) Ground zero of my system configuration
- [lib](lib) 📚 Personal library of functions and utilities
  - [flake](lib/flake) ❄️ Extended functions or configuration imports for my flake.nix
- [docs](docs) The documentation for my flake repository
  - [notes](docs/notes) Notes from tedious or/and underdocumented processes I have gone through
- [home](home) 🏠 my personalized [Home-Manager](https://github.com/nix-community/home-manager) module
- [modules](modules) 🍱 modularized NixOS configurations
  - [common](modules/common) ⚙️⚙ The common modules imported by all hosts
    - [core](modules/shared) 🧠 Core NixOS configuration
    - [boot](modules/boot) 🔧 Default configuration for common bootloaders
    - [system](modules/system) 💡 A self-made NixOS configuration to dictate system specs
  - [extra](modules/extra) 🚀 Extra modules that are rarely imported
    - [server](modules/extra) ☁️ Shared modules for "server" purpose hosts
    - [desktop](modules/desktop) 🖥️ Shared modules for "desktop" purpose hosts
    - [virtualization](modules/virtualization) 🪛 Hot-pluggable virtualization module for any host
  - [shared](modules/shared) ☁️ Modules that can be consumed by external flakes
- [hosts](hosts) 🌳 per-host configurations that contain machine specific configurations
  - [enyo](hosts/enyo) 🖥️ My desktop computer boasting a full AMD system.
  - [prometheus](hosts/prometheus) 💻 My HP Pavillion with a NVIDIA GPU
  - [epimetheus](hosts/epimetheus) 💻 The succeeding brother host to prometheus, with full disk encryption
  - [hermes](hosts/hermes) 💻 My new HP Pavillion with a Ryzen 7 7730U
  - [helios](hosts/helios) ⚡ Hetzner VPS for self-hosting some of my infrastructure
  - [atlas](hosts/atlas) 🍓 Proof of concept server host that is used by my Raspberry Pi 400
  - [icarus](hosts/icarus) 💻 My 2014 Lenovo Yoga Ideapad that acts as a portable server and workstation
  - [gaea](hosts/gaea) 🌱 Custom iso build to precede all creation
    - [artemis](hosts/artemis) 🏹 x86_64-linux VM Host
    - [apollon](hosts/apollon) ⚔️a aarch64-linux VM Host
- [pkgs](pkgs) 📦 Packages exported by my flake

## Notes

### Preface

If my configuration appears confusing to you, that is because it is confusing.
Admitably, I am not yet very well wresed in NixOS or the Nix expression language.
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
can be found in [the documentation](../docs/notes). Should you need explanation on
some of the things I've done (or proofread my notes) you may take a look in there.

### Motivation

I so often switch devices due to a myriad of reasons. Regardless of the reason,
I would like to be able to get my new devices up and running in minutes. Thanks
to the declarative nature of NixOS, I can do just that on top of being able to
build entire system from a few modules and nothing more. Which is why I am currently
in the process of transitioning all of my devices to NixOS. While I do have much to learn
the NixOS ecosystem is an incredible learning opportunity and a good practice for
those who want to switch inbetween devices at ease, or have common "mixin"
configs that are shared between multiple devices. All things considered, it is
an excellent idea to learn Nix (the programming language) and NixOS.

I also maintain some dotfiles for my desktop running Arch Linux. See the [arch](../../../tree/arch)
branch if you are interested in my "legacy" dotfiles.

### Disclaimer

> I am not a NixOS _expert_. I am a NixOS _user_.

You _probably_ do not want to copy or base your config off of this configuration.
Frankly, this is not a community framework, and nor is it built with the intention of bringing
new people into NixOS or/and helping newcomers figure out how NixOS works.
It is simply my NixOS configuration, built around my personal use cases and interests.
If you do have a question, I will do my absolute best to answer it as the
circumstances (mainly my own knowledge) allow, however, do not expect "support"
and definitely do not assume this configuration to be following best practices.

Dissect the configurations all you want, take what you need and if you find yourself to
be excelling somewhere I lack, do feel free to contribute to my atrocities against
NixOS and everything it stands for. Would be appreciated.

_Styling PRs will be rejected because I like my Alejandra, thanks but no thanks._

## Donate

Want to support me, or to show gratitude for something (somehow) nice I did?
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
[spikespaz](https://github.com/spikespaz/dotfiles) -

... and many more

### Other Cool Resources

> Resource that helped shape and improve this configuation, or resources that I strongly recommend that you read.

- [Vinícius Müller's Blog](https://viniciusmuller.github.io/blog)
- [A list of Nix library functions and builtins](https://teu5us.github.io/nix-lib.html)
- [Viper's Blog](https://ayats.org/)

## License

This repository is licensed under the [GPL-3.0](../LICENSE) license.
