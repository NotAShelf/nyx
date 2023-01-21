Note: The system-module branch is for the upcoming QoL rework and is in REALLY
early development. See the `nixos` module for the last stable version.

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

<p align="center">
   <img src="assets/desktop_preview.png" width="640" alt="" />
</p>

## 📦 Overview

- [Flake](flake.nix) Ground zero of my system configuration
- [lib](lib) 📚 Personal library of functions and utilities
- [docs](docs) Documentation for myself and for people who want to understand this system
- [home](modules/home) 🏠 my [Home-Manager](https://github.com/nix-community/home-manager) config
- [modules](modules) 🍱 modularized NixOS configs
  - [bootloader](modules/bootloader) ⚙ Various bootloaders for various purpose hosts
  - [core](modules/core) 🧠 Core NixOS configuration
  - [server](modules/server) ☁️ Shared modules for "server" purpose hosts
  - [desktop](modules/desktop) 🖥️ Shared modules for "desktop" purpose hosts
  - [system](modules/system) 🚀 A self-made NixOS configuration to dictate system specs
  - [virtualization](modules/virtualization) Hot-toggled virtualization module for any host
- [hosts](hosts) 🌳 per-host configuration
  - [prometheus](hosts/prometheus) 💻 My 2016 HP Pavillion with NVIDIA GPU
  - [atlas](hosts/atlas) 🍓 Raspberry Pi 400 that acts as my home lab
  - [icarus](hosts/icarus) 💻 My 2014 Lenovo Yoga Ideapad that acts as a portable server and workstation
  - [gaea](hosts/gaea) 🌱 Custom iso build to precede all creation
- [pkgs](pkgs) 💿 exported packages
  - [overlays](modules/overlays) 📦 Overlay recipes for my system to use


## Notes

If my dotfiles are confusing to you, that is because they are confusing. I am not
yet very well versed in NixOS and Nix, thus my configuration may not always follow best
practices or be the most efficient. I also do not follow any particular logic when
organizing my configuration. I do, however, try my best to document my NixOS configuration
as humanly possible. This repository was based off of *many* others which I have linked below.
If you like anything about this repository, you will probably like theirs as well. If you have anything
to say/ask about those configurations (especially if it was because you were disgusted by
my atrocities against NixOS), please do not hesitate to make an issue or open a PR. I am always
happy to learn and improve. With that said, if you like this repository maybe consider starring it
or donating me from the links below, up to you.

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

I also maintain some dotfiles for my desktop running Arch Linux. See the [main](tree/main)
branch if you are interested in my "legacy" dotfiles.

### Disclaimer

> I am not a NixOS *expert*. I am a NixOS *user*.

You *probably* do not want to copy or base your config off of this configuration.
Frankly, this is not a community framework, and nor is it built with the intention of bringing
new people into NixOS or/and helping newcomers figure out how NixOS works.
It is simply my NixOS configuration, built around my personal use cases and interests. 
If you do have a question, I will do my absolute best to answer it as the 
circumstances (mainly my own knowledge) allow, however, do not expect "support" 
and definitely do not assume this configuration to be following best practices.

Dissect the configurations all you want, take what you need and if you find yourself to 
be excelling somewhere I lack, do feel free to contribute to my atrocities against
NixOS and everything it stands for. Would be appreciated. 

*Styling PRs will be rejected because I like my Alejandra, thanks but no thanks.*

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

...or if you prefer crypto *(those are not active yet due to my lack of interest in cyptocurrencies)*

Ethereum: ` `

Monero/Bitcoin: notashelf.dev (OpenAlias)

## Credits & Special Thanks to

### System Configurations

> I ~~shamelessly stole from~~ got inspired by those folks

[sioodmy](https://github.com/sioodmy) -
[rxyhn](https://github.com/rxyhn) -
[fufexan](https://github.com/fufexan) -
[hlissner](https://github.com/hlissner) -
[fortuneteller2k](https://github.com/fortuneteller2k)

... and many more

### Other Cool Resources

> Resource that helped shape or improve this configuration

- [Vinícius Müller's Blog](https://viniciusmuller.github.io/blog)


## License

This repository is licensed under the [GPL-3.0](../LICENSE) license.
