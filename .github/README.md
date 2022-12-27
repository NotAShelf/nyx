<h1 align="center">
  <img src="https://camo.githubusercontent.com/8c73ac68e6db84a5c58eef328946ba571a92829b3baaa155b7ca5b3521388cc9/68747470733a2f2f692e696d6775722e636f6d2f367146436c41312e706e67" width="100px" /> <br>
  
  NotAShelf's NixOS Configurations <br>
  <img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/palette/macchiato.png" width="600px" /> <br>
  <div align="center">

  <div align="center">
   <p></p>
   <a href="">
      <img src="https://img.shields.io/github/issues/notashelf/dotfiles?color=fab387&labelColor=303446&style=for-the-badge">
   </a>
   <a href="https://github.com/notashelf/dotfiles/stargazers">
      <img src="https://img.shields.io/github/stars/notashelf/dotfiles?color=ca9ee6&labelColor=303446&style=for-the-badge">
   </a>
   <a href="https://github.com/notashelf/dotfiles/">
      <img src="https://img.shields.io/github/repo-size/notashelf/dotfiles?color=ea999c&labelColor=303446&style=for-the-badge">
   </a>
   <a href="https://github.com/notashelf/dotfiles/blob/main/LICENSE">
    <img src="https://img.shields.io/static/v1.svg?style=for-the-badge&label=License&message=GPL-3&logoColor=ca9ee6&colorA=313244&colorB=cba6f7"/>
   </a>
   <a href="https://liberapay.com/notashelf/donate"><img src="https://img.shields.io/liberapay/patrons/notashelf.svg?logo=liberapay?color=e5c890&labelColor=303446&style=for-the-badge"></a>
   <br>
</div>
</h1>

## 📦 Overview

- [Flake](flake.nix) Ground zero of my system configuration
- [lib](lib) 📚 Personal library of functions and utilities
- [modules](modules) 🍱 modularized NixOS configs
  - [home](modules/home) 🏠 my [Home-Manager](https://github.com/nix-community/home-manager) config
  - [bootloaders](modules/bootloaders) ⚙ Various bootloaders for various purpose hosts
  - [core](modules/core) 🧠 Core NixOS configuration
  - [server](modules/server) ☁️ Shared modules for "server" purpose hosts
  - [desktop](modules/desktop) 🖥️ Shared modules for "desktop" purpose hosts
  - [wayland](modules/wayland) 🚀 Wayland-specific configurations and services
  - [overlays](modules/overlays) 📦 Overlay recipes for my system to use
  - [hardware](modules/hardware)
    - [nvidia](modules/hardware/nvidia) 💚 My next GPU won't be NVIDIA
    - [intel](modules/hardware/intel) 💙 Common configuration for Intel CPUs
    - [amd](modules/hardware/amd) ❤️ Configuration set for my future AMD laptop
- [hosts](hosts) 🌳 per-host configuration
  - [prometheus](hosts/prometheus) 💻 My 2016 HP Pavillion with NVIDIA GPU
  - [atlas](hosts/atlas) 🍓 Raspberry Pi 400 that acts as my homelab
  - [icarus](hosts/icarus) 💻 My 2014 Lenovo Yoga Ideapad that acts as a portable server and workstation
- [pkgs](pkgs) 💿 exported packages

## Notes

## Motivation

I so often switch devices due to a myriad of reasons. Regardless of the reason,
I would like to be able to get my new devices up and running in minutes. Thanks
to the declarative nature of NixOS, I can do just that. Which is why I am
currently transitioning all of my devices to NixOS. While I do have much to learn
the NixOS ecosystem is an incredible learning opportunity and a good practice for
those who want to switch inbetween devices at ease, or have common "mixin"
configs that are shared between multiple devices. All things considered, it is
an excellent idea to learn Nix (the programming language) and NixOS.

I also maintain some dotfiles for my desktop running Arch Linux. See the [main](tree/main)
branch if you are interested in my "legacy" dotfiles.

## Donate

Want to support me, or to show gratitude? Consider donating

via [liberapay.com/notashelf](https://en.liberapay.com/notashelf/)

<a href="https://liberapay.com/notashelf/donate"><img alt="Donate using Liberapay" src="https://liberapay.com/assets/widgets/donate.svg"></a>

... or if you prefer crypto

Ethereum: ``

Monero/Bitcoin: notashelf.dev

## Credits & Special Thanks to

I ~~shamelessly stole from~~ got inspired by those folks

[sioodmy](https://github.com/sioodmy) -
[rxyhn](https://github.com/rxyhn) -
[fufexan](https://github.com/fufexan) -
[hlissner](https://github.com/hlissner) -
[fortuneteller2k](https://github.com/fortuneteller2k) -

