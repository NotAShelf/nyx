 # Changelog

 ## [Unreleased]

### Changed

- flake: pin Hyprland

build fails

- flake: pin Hyprland

- environment/variables: set `LESS` and `SYSTEMD_LESS`

- environment/packages: explain `defaultPackages` that are removed

- roles/iso: pin nix registry; set nixPath

- system/fonts: explicitly enable fontconfig

- modules/core: move `nix-output-monitor` overlay to `nh.nix`

- tools/nix-index: disable zsh hook

- tools/gpg: cleanup

- tools/fzf: init

- shell/zsh: completion cleanup; move fzf-tab

- flake/pre-commit: ignore valid spelling

- shell/zsh: completion cleanup

- services/earlyoom: harden service

- flake: update inputs

- themes/qt: clean up qt module; fix gtk compat

- editors/neovim: enable neovim-flake manpages

- flake: bump inputs

- services/ntpd: listen on loopback only

- themes/qt: follow new platformTheme options

- hosts/enyo: bump xanmod kernel to 6.8.7

- flake: update inputs; lock nix-super

- editors/neovim: let nvf handle spellchecking

- editors/neovim: bring back neovide config

- flake: update inputs

- roles/headles: move MOTD to `user.motd`

- programs/nh: use the module in nixpkgs

- flake: update inputs

- treewide: luals config

- tools/ripgrep: init

- flake: follow nixpkgs-small for faster nixpkgs hotfixes

- editors/neovim: cleanup; switch to stable neovim

- terminal/editors: use neovim-nightly

- flake: update neovim-flake

- programs/graphical: use `foot` instead of `footclient`

- hosts/enyo: bump xanmod kernel to 6.8.6

- flake: update neovim-flake

- flake/npins: update sources

- flake: update inputs

- flake/shell: use mkShellNoCC

- flake: update inputs

- system/nix: document `documentation.nixos.enable`

- docs: use permalink for nix logo in README; fix typos

- docs: restyle; add custom 404 page

- docs: init changelog

- flake: exclude changelog in git-cliff

- flake/pre-commit: don't uppercase git-cliff changelogs

- flake/pre-commit: ignore valid spelling

- packcages/gui: drop redundant hardware dependencies

- apps/librewolf: init

- flake: update inputs

- flake: break pre-commit hooks into multiple files

- system/nix: clear insecure package list; bail early on missing cache hits

- os/activation: get mkIf from lib.modules

- apps/webcord: update catppuccin theme file

- modules: move session packages out of xsession module

- flake/apps: shellcheck

- flake: disable git-cliff

- flake: provide locals apps and checks

- hosts/erebus: resolve option conflicts

- networking/headscale: ssh ACLs

- common/system: document zram/vm_map_count

- services/networking: finish up ACLs

- services/bincache: leave instructions for nix-serve

- flake: rename pre-commit-hooks to git-hooks.nix

- hosts/enyo: clarify RouteMetric usage in networkd config

- services/networking: break headscale config into multiple files

- os/services: timesyncd -> openntpd

- hosts/helios: allow tailscale derp

- secrets: clean up secret paths

- system/gaming: pass SDL_VIDEODRIVER to steam override

- os/networking: tag hosts

- hosts/enyo: bump xanmod kernel to 6.8.5

- flake: update inputs

- shell/zsh: clean up comment structure

- networking/headscale: initial ACL setup

- flake: update inputs

- flake: update inputs

- shell/zsh: better doc comments

- shell/zsh: describe loaded modules

- shell/zsh: prefix custom functions with `__`

- editors/neovim: nvf v0.6 fix for nvim-session-manager setupOpts

- shell/zsh: new init options

- tools/git: skip smudges in git LFS

- flake: bump inputs

- CI: print build logs for check workflow

- CI: install qemu; add aarch64 to platforms

- editors/neovim: markdown previews

- editors/neovim: switch to new setupOpts API

- docs: mobile compatibility

- flake: bump inputs

- hosts/enyo: drop redundant ccache override

doesn't work

- flake: bump inputs

- docs: cleanup

- docs: switch to jsonfeed spec; drop xml feed

- os/networking: modularize networking config internally

- networking/firewall: nftables compatibility for fail2ban

- flake: bump inputs

- hosts/enyo: remove deprecated  usage

- flake: force snm to follow nixpkgs-small

faster updates

- flake: bump inputs

- docs: cleanup

- docs: generate about and privacy pages properly

- docs: get post data from `posts/posts.json`

- docs: re-organize generated static site

- docs: include table of contents in posts

- environment/packages: describe `defaultPackages` and `systemPackages` better

- hosts/enyo: xanmod 6.8.4

- flake: bump inputs

- docs: ensure about and privacy pages are generated correctly

- docs: don't embed resources

doing so has slowed the website almost to a halt, oof

- CI: execute script with bash

- flake: bump inputs

- flake: bump inputs

- hosts/enyo: disable CIFS support

- docs: build with pandoc templates

- docs: better wording in the docs/notes README

- docs: fold all notes

- roles/iso: move generic installer configuration to the role module

- system/security: drop fs hardening

- flake: bump inputs

- modules: move media and gaming options to `usrEnv`

- hosts/leto: cleanup; remove hardware.nix

- homes: make doc comments consistent

- hosts/enyo: call custom kernel as a package

- os/boot: allow mix and matching custom and mainline kernels

- flake: bump inputs

- wms/hyprland: float steam settings window

- flake: bump inputs

- hosts/enyo: clean up kernel config; extend hardening

- system/security: remove unnecessary workaround for `nixpkgs#278090`

- common/nix: store builder key in ~/.ssh

- terminal/tools: split git config

- flake: bump inputs

- common/nix: set sshProtocol for the default builder

- system/security: remove `noexec` from `/`

/tmp, where most builds occur, will be  if /tmp is not on tmpfs

- os/boot: use linuxPackagesFor w/ booted kernel

- hosts/enyo: structure kernel config

- hosts/enyo: remove system.kernel from modules/system

- hosts/enyo: separate kernel config & package

- flake: bump inputs

- packages/gui: disable gnome-control-center

- gaming/gamescope: use the gamescope package option for the wrapper

- gaming: set `vm.max_map_count` for better performance

- core/nix: follow xdg spec; abstract builders

- virtualization/qemu: allow host <-> VM networking

- secrets: rekey all

- services/ags: align notification body & title

- flake: bump inputs

- hardware/gpu: use the new nvtop package names`

- Merge pull request #59 from NotAShelf/kernel-patches

hosts/enyo: provide local kernel patches
- hosts/enyo: disable /tmp on tmpfs

- hosts/enyo: provide local kernel patches

- services/ags: init media module

- services/ags: align notification title and body

- services/ags: cleanup

- Merge pull request #64 from NotAShelf/separate-package-opts

treewide: move userspace programs to `usrEnv.programs`
- treewide: move userspace programs to `usrEnv.programs`

- treewide: follow neovim luarc for lua_ls

- homes/notashelf: move mpd companion programs to programs/ dir

- flake: remove schemas

- Merge pull request #61 from NotAShelf/ags-notifs

services/ags: cleanup
- services/ags: init notification widget

- services/ags: reorganize bar widgets

- services/ags: move to sassc mixis for bar components

- services/ags: cleanup

- shared/media: post-refactor cleanup

- services/shared: clean up media services

- shared/kdeconnect: disable for now

- tools/transient-services: sanitize values in key-value pairs

- apps/webcord: override arRPC package

- modules/roles: post-refactor cleanup

- core/profiles: import gaming profile

- virtualization/qemu: disable dynamic file ownership

- modules: import previously missing theming config

- flake: bump inputs

- flake/pre-commit: move to new module option format

- flake: unpin simple-nixos-mailserver

- hosts: import graphical pluggable on workstation hosts

- roles: move some of the 'workstation' features to 'graphical'

- flake: bump inputs

- flake: bump inputs

- flake: use exposed treefmt wrapper for `nix fmt`

- docs: re-organize README

- hosts/artemis: drop bcachefs kernel in favor of latest kernel

- nix/transcend: lock fetchTree inputs

- CI: enable fetch-tree experimental feature in Nix workflows

- style: reorganize transcend args

- CI: move away from DetSys nix installer

- flake: bump inputs

- flake: move more parts to their dedicated directories

- flake.lock

flake: drop nix-gaming

- system/gaming: get proton-ge from nixpkgs

nix-gaming can probably be dropped entirely?

- options/media: get mpv-history script from `nyxpkgs`

- flake: bump inputs

- flake: bump inputs

- wms/i3: i3status-rs configuration

- flake: bump inputs

- shell/zsh: split zsh config into multiple files

- shell/starship: new git status icons

- flake: pin v0.6 branch of nvf

- wms/i3: tweak configuration

- editors/neovim: disable spellchecking in terminal window

- flake: bump inputs

- environment/locale: rename deprecated xkb options

- services/misc: write additional systemd configuration to speed up boot

- wms/i3: tweak default keybinds

- services/login: fall back to tuigreet when graphical session is terminated

- flake: update schizofox

- editors/neovim: move yank config to autocmds; rename autocommands.lua

	new file:   homes/notashelf/programs/terminal/editors/neovim/lua/autocmds.lua
	deleted:    homes/notashelf/programs/terminal/editors/neovim/lua/yank.lua
	deleted:    homes/notashelf/programs/terminal/editors/neovim/lua/autocommands.lua

- tools/gpg: pinentryFlavor -> pinentryPackage

- flake: bump nixpkgs input

- os/networking: revise ssh mac and kex algorithms

- sound/pipewire: drop nix-gaming low-latency modulee

- services/logrotate: configure rotation frequency

- tools/gpg: change graphical pinentryFlavor to gtk2 (previously gnome3)

- flake: bump inputs

- media/mpd: remove deprecated daemon options

- hosts/enyo: snapshot /home weekly

- tools/eza: disable zsh integration

- flake: bump inputs

- wms/hyprland: force input in Helldivers 2 window

- flake: unpin hyprland

- modules: deprecate local and nix-gaming sourced steamCompat modules

- flake: bump inputs

- environment/locale: set xserver locale

- Merge pull request #60 from NotAShelf/dependabot/github_actions/softprops/action-gh-release-2

build(deps): bump softprops/action-gh-release from 1 to 2
- build(deps): bump softprops/action-gh-release from 1 to 2

Bumps [softprops/action-gh-release](https://github.com/softprops/action-gh-release) from 1 to 2.
- [Release notes](https://github.com/softprops/action-gh-release/releases)
- [Changelog](https://github.com/softprops/action-gh-release/blob/master/CHANGELOG.md)
- [Commits](https://github.com/softprops/action-gh-release/compare/v1...v2)

---
updated-dependencies:
- dependency-name: softprops/action-gh-release
  dependency-type: direct:production
  update-type: version-update:semver-major
...

Signed-off-by: dependabot[bot] <support@github.com>
- hosts/atlas: remove duplicate fs import

- hosts/icarus: remove redundant hardware import

- hosts/prometheus: remove unnecessary hardware import

- roles/iso: remove duplicate parent attribute in tags

- flake: bump inputs

- editors/neovim: adjust fidget.nvim winblend

- editors/neovim: clean up autocmds

- flake: switch to v0.6 branch of neovim-flake

- programs/games: remove yuzu

- flake: bump inputs

- services/nginx: look for index inside server root

- flake: bump inputs

- flake: bump inputs

- treewide: move lua helper configs to project root

- editors/neovim: lua config for basic neovim settings

- os/users: tweak root and builder accounts

- core/roles: tag pluggable role modules accordingly

- os/services: tweak fstrim systemd service settings

- tools/zellij: tweak system layout

- media/mpv: use mkMerge for merging keybinds

- flake: bump inputs

- tools/zellij: improve default system layout

- editors/neovim: KDL treesitter grammar

- treewide: lua LSP rulesets

- docs: clean up README

- treewide: linguist

- treewide: tweak luacheck for (neo)vim

- flake: bump inputs

- treewide: cleanup

- editors/neovim: finish separating plugin configurations

- tools/zellij: provide system layout

- tools/yazi: set cache dir correctly

- services/nginx: construct static pages

- flake: bump inputs

- security/apparmor: provide apparmor utils while enabled

- treewide: let linguist pick up markdown files

- nix/overlays: style changes

- sound/pipewire: temporarily move to the config packages format

- apps/thunderbird: disable birdtray

- flake: bump inputs

- apps/thunderbird: bind birdtray to tray.target

- services/systemd: bind brightness service to graphical-session target

- networking/tcpcrypt: remove hardening options

- editors/neovim: construct local modules automatically

- services/ags: use the correct path for desktop button scripts

- services/ags: refactor audio popups to fix trigger events

- editors/neovim: enable tailwindcss LSP

- flake: bump inputs

- flake: bump inputs

- workstation/login: re-organize greeter profiles

- graphical/thunderbird: write settings; provide basic birdtray config for notifs

- hosts/hermes: remove missing hardware import

- editors/neovim: post-refactor cleanup

- flake: bump inputs

- system/hardware: enable redistributable hardware by default

or risk breaking gpu drivers, again

- editors/neovim: refactor; break into multiple parts

- editors/neovim: use wezterm in neovim wrapper

- hosts: declutter argSets

- graphical/minecraft: wrap prismlauncher from nixpkgs

- flake: get rid of prismlauncher flake

- services/ags: recompile stylesheet

- flake: reorganize; switch to alejandra-no-ads

- Merge pull request #58 from NotAShelf/omit-hardware-nix

treewide: get rid of `hardware.nix` for all hosts
- treewide: get rid of host-specific `hardware.nix`; move hardware config to mixins

- lib/builders: shadow `nixpkgs.hostSystem` into `mkNixosSystem`

- os/networking: use `system.checks` to pin IFD

- flake: bump inputs

- system: activation -> os/activation

- system/theme: init

- services/ags: rename `scss` directory to `style`

- services/ags: recompile stylesheets; consistent OSD widgets

- graphical/hyprland: tweak blur rules

- graphical/wlogout: init style config

- system/nix: permit freeimage-unstable

- flake: bump inputs

- Merge pull request #57 from NotAShelf/ags-swallow

services/ags: swallow
- flake: unpin hyprland

- services/nginx: move to standalone directory; serve static plaintext

- services/logrotate: init config

- services/ags: swallow sstatus in the label

- services/ags: refactor

- services/ags: replace all deprecated `binds` and `connections` usage

- flake: unpin hyprland

- flake: bump inputs

- system/boot: provide default kernel

- hyprland/packages: simplify

- emulators/wezterm: normalize font

- tools/fastfetch: init

- services/nginx: move to standalone directory; serve static plaintext

- services/logrotate: init config

- services/wayland: handle deprecated items

- wms/hyprland: split config sections

- hosts/helios: specify kernel

- networking/firewall: disable opensnitch on headless systems

- wms/hyprland: use wrapper for session launch

hopefully preserves important variables better than sessionVariables by home-manager

- modules/usrEnv: init backlight submodule

- flake: bump inputs

- flake: pin hyprland to last branch with mouse locking

- securit/memalloc: disable memalloc hardening

causes mass rebuilds due overlay

- networking/tcpcrypt: allow access to /proc/sys/net/ipv4

- flake: bump inputs

- modules/boot: assert if host does not define a kernel package

- core/secrets: remove redundant dev.type gating

- modules/core: move gaming module under system

- modules/docs: expose built packages as module options

- system/security: memory allocator hardening

- shell/starship: shorten well-known locations without `~`

- flake: bump inputs

- hosts/enyo: remove nixos-generate-config networking opts

- networking/tcpcrypt: initial systemd service hardening

- Merge pull request #55 from NotAShelf/module-docs-gen

modules: generate internal documentation
- Merge branch 'main' into module-docs-gen
- services/ags: use the correct nerdfonts icon in tray

- Merge branch 'main' into module-docs-gen
- terminal/shell: tweaks to shell configurations

- Merge branch 'main' of github.com:NotAShelf/nyx

- tools/tealdeer: disable

- editors/neovim: provide neovide configuration

- options/docs: minor tweaks to the stylesheet

- modules/options: rename options/documentation; provide pandoc template

- modules/documentation: init

- I cannot emphasize this enough: **FUCK**

thanks for attending to my ted talk

- shell/starship: minify promptt

- editors/neovim: disable spellchecking

- emulators/wezterm: rewrite config; better colors

- securit/apparmor: enable on x86_64 explicitly

- flake: bump inputs

- homes/notashelf: manage dconf settings declaratively

- os/programs: tell bash to use xdg spec

- tools/tealdeer: disable auto_update

- tools/zellij: init

keybinds needed

- terminal/foot: reorganize config options

- editors/neovim: enable spellchecking

- terminal/wezterm: detect colorscheme automatically

- editors/neovim: disable neocord

- flake: reorganize flake-parts imports

- flake: bump inputs

- CI: handle build matrix separately

- CI: deduplicate publish jobs

- os/networking: begin rewriting the tcpcrypt service

- lib/builders: include hostname as an arg in mkNixosSystem

- roles/headless: force disabled features

- treewide: minor cleanup

- direnv: watch flake-parts imports

- flake: bump inputs

- apps/webcord: build arRPC from source

- apps/webcord: use arrpc from nixpkgs

- hosts/hermes: try out systemd-networkd

- os/networking: refactor networking module; configurable imperative networking

- boot/generic: make silentBoot option more viable

- hardware/tpm: explain tciEnvironment.enable

- roles/iso: use zstd compression

- roles/headless: disable unnecessary services; reduce size

- CI: clean up ISO build workflow

- flake: drop arrpc-flake instead of the home-manager module

- homes/notashelf: move element to its own module; write json config

- flake: switch to working simple-nixos-mailserver fork

- flake: bump inputs

- os/networking: doc comments

- programs/git: cleanup; extend configuration and generate ignores

- themes/gtk: configure gtk3/gtk4 natively

- display/xorg: cleanup

- security/pki: init; disable certificate bundless from countries I do not care about

- security/apparmor: always enable

- Merge pull request #54 from NotAShelf/expand-theming

treewide: extend theme module usage
- docs: remove nix-colors mentions from readme

- notashelf/themes: minor cleanup in nix syntax

- treewide: deprecate nix-colors usage; move to internal theming module

- flake: bump inputs

- docs: remove duplicate header

- networking/tailscale: clean up option definitions; unify upflags for systemd services

- docs: tidy up

- misc/console: change default fonts

- common/system: refactor xdg portal configurations

- services/nextcloud: extraOptions -> settings

- themes/palettes: conform to upstream changes

- flake: bump inputs

- Merge pull request #53 from NotAShelf/docs-refactor

treewide: clean up documentation
- docs: move desktop preview to the end of the file

- docs: update README and cheatsheet; remove todo

- flake: reduce depth in flake modules

- treewide: use double spacing for markdown files

- hosts/enyo: refactor & initial systemd-networkd testing

- os/networking: allow imperative networking via wpa_cli

- services/runners: recognize appimages automagically

- services/ags: re-organize widgets

- homes/notashelf: write wlogout config in ~/.config

- system/security: detach apparmor config from kernel

- roles/laptop: remove unnecessary device type checks

- flake: bump inputs

- hardware/bluetooth: switch to experimental

- homes/notashelf: enable udiskie again

- flake: bump inputs

- roles/server: enable quic support in nginx configurations

- secrets: organize secret paths

- secrets: rekey all

- Merge pull request #51 from NotAShelf/nginxQuic

services/nginx: enable nginxQuic
- services/nginx: enable nginxQuic

- flake: bump inputs

- editors/neovim: enable markdown LSP

- os/misc: console should be overridable without mkForce

aarch64 builds don't play nicely

- Merge pull request #50 from roastedcheese/main

hosts: fix typos
- flake: bump inputs

- hosts/enyo: enable swaylock

- modules/impermanence: refactor module, remove unintentional nesting

- Merge pull request #49 from roastedcheese/patch-1

fix typos
- CI: use matrix to pick up files for release

- nix/transcend: remove merged nix-settings PR

- CI: build with a matrix

- roles/iso: fall back to "nixos" if hostname is not found

- flake: remove hydraJobs

- CI: provide uniform "release notes" for ISO releases

- roles/iso: init; streamline liveiso setup

- services/ags: refactor more aggressively

- wms/hyprland: switch to wpctl for volume binds

- services/ags: convert weather module to the new syntax

- services/ags: simplify major services

- services/ags: convert more modules to the new syntax

- lib/helpers: services.nix -> modules.nix

- CI: un-escape `$` in date step

- treewide: remove all instances of `with lib;`

- core/roles: move adb to workstation

- CI: try to get iso paths correctly

- options/system: break services module into multiple files

it was getting out of hand

- services/mailserver: mark send-only accounts as such

- services/hydra: init

- tools/neomutt: initial configuration & mailaccount setup

- os/networking: quad9 ipv6

- tools/xdg: provide XDG_MAIL_DIR

- os/networking: cloudflare ipv6

- options/usrEnv: remove whitespaces in module descriptions

- services/zram: document relevant sysctl parameters

- flake: remove nixpkgs-wayland

- firewall/fail2ban: docs

- hosts/hermes: nomux and nopnp for i8042 module

- virtualization/qemu: onBoot and onShutdown setup

- security/kernel: correct parameter formats according to journal

- core/common: move kmscon setup to console config

- secrets: secrets for neomutt

- homes/notashelf: refactor, reduce directory depth

- roles/microvm: minor tweaks

- hosts/hermes: enable qemu virt & disable docker

- hosts/helios: open port 22

- flake: bump nyxpkgs input

- hosts/helios: open snm ports on firewall

- system/nix: bring back harmonia instance

- hosts/helios: pass https to firewall

- system/nix: disable harmonia

- options/usrEnv: default to no desktop env

- hosts/helios: enable nftables

- Merge pull request #44 from NotAShelf/treewide-refactor

treewide: refactor to better conform to previous module changes
- Merge branch 'main' into treewide-refactor
- Merge pull request #48 from Amanse/main

nix-ify propaganda
- nix-ify propaganda

- Merge pull request #46 from NotAShelf/dependabot/github_actions/cachix/cachix-action-14

build(deps): bump cachix/cachix-action from 13 to 14
- build(deps): bump cachix/cachix-action from 13 to 14

Bumps [cachix/cachix-action](https://github.com/cachix/cachix-action) from 13 to 14.
- [Release notes](https://github.com/cachix/cachix-action/releases)
- [Commits](https://github.com/cachix/cachix-action/compare/v13...v14)

---
updated-dependencies:
- dependency-name: cachix/cachix-action
  dependency-type: direct:production
  update-type: version-update:semver-major
...

Signed-off-by: dependabot[bot] <support@github.com>
- Merge branch 'main' into treewide-refactor
- flake: bump flake inputs

- services/wayland: move screenlock under programs, use options

- wms/hyprland: use writeShellApplication for hyprshot

- system/nix: move overlays to their own file

- launchers/anyrun: write stylesheets in scss

- laptop/power: remove cpupower-gui

- launchers/anyrun: configure max_entries for nixos options plugin

- common/gaming: move chess module to graphical/games

- flake: bump flake inputs

- programs/media: make default media packages and mpv scripts customizable

- graphical/launchers: use launchers.<name>.enable

- graphical/wms: use desktops.<name>.enable

- hosts[enyo, hermes]: enable rofi and anyrun, remove deprecated opt

- programs/graphical: all files on the same level

- headless/system: remove deprecated services import

- modules/options: move noise supression to programs, lockers to usrEnv and assert

- docs: classic nix logo in readme

- gaming/gamemode: security wrap with ptrace capabilities

- hosts[enyo, hermes]: use the new profiles module

- modules/options: init internal meta module

- core/profiles: init gaming profile

- roles/microvm: enable zsh autocompletions and suggestions

- games/minecraft: use inherit

- treewide: refactor to better conform to previous module changes

...and possibly improve eval speeds? probably not

- Merge pull request #43 from NotAShelf/programs-refactor

treewide: programs refactor
- modules: provide profile features in role modules

- homes/notashelf: restructure apps directory

- treewide: move program options under system module

- hosts: move local module options to their own files

- hosts: include host types in the table

- system/security: fingerprint support

- flake/templates: use vendorSha256

- modules: minor cleanup in docs and definitions

- os/networking: configure iwd

- flake: bump flake inputs

- system/security: initial usbguard configuration

- virtualization/waydroid: wrap waydroid-ui in a kiosk session

- services/searxng: cleanup

- services/searxng: use redis socket

- services/nginx: load zstd module

- os/misc: testing kmscon

- roles/microvm: network isolation

- flake/pkgs: pin rfc-101 branch properly for nixfmt

- services/media: re-enable beets tagger

- flake/pkgs: get nixfmt from rfc101 branch

- CI: use reusable workflows

- security/sudo: force execWheelOnly

- os/networking: close stale ssh sockets automatically

- os/systemd: adjust nix-daemon OOM score

- os/environment: switch to powerline-fonts in the terminal

- workstation/system: mkForce cgroupsv2 support

- server/system: disable fontconfig on servers

- editors/neovim: supress lib.getExe warning

- services/nextcloud: rename deprecated nextcloud opts

nextcloud maintainers should be prosecuted for the new naming scheme

- Merge pull request #40 from NotAShelf/refactor-services

server/services: refactor
- common/secrets: enable tailscale secret unconditionally

- system/services: use central module definitions to configure services

- services/mailserver: set vmail info

- services/uptime-kuma: set user and group explicitly

- services: rename more obsolete and renamed options

- CI: publish ISO images

- system/services: naming

- system/services: call nginx from services that need it

- system/services: manually enable nginx by services that need it

- system/services: start using hosts and ports

harmonia & attic

- CI: inherit the token correctly in the check workflow

- hosts/images: remove unused host image

- CI: use reusable workflows and publish built ISO images

- options/services: construct service options automatically

- server/services: separate social modules

- treewide: drop unused patterns

round 2

- treewide: drop unused patterns

round 1

- system/nix: correct ags cachix pubkey

- services/ags: reduce gaps around the bar widget

- wms/hyprland: reduce gaps

- flake: bump inputs

- homes/terminal: restructure, add yazi config

- flake: bump inputs

- flake: bump inputs

- networking/tailscale: autologin service

- security/kernel: disable ptrace patches until gamescope works

- apps/schizofox: streamline addon installation

- apps/schizofox: enable session restore manually

- modules: organize by function, cleanup

- flake: bump inputs

- system/virtualization: deconstruct virtualization module

- CI: switch back to detsys nix installer

- CI: switch back to detsys nix installer

- services/forgejo-runner: enable cache & set capacity

- services/nextcloud: get rid of the pre-generate script

- ci: try cachix nix installer

- Merge pull request #42 from NotAShelf/deploy-rs

flake: deployments via deploy-rs
- flake: deployments via deploy-rs

- editors/neovim: slides.nvim

- flake: bump inputs

- security/kernel: disable unprivileged ptrace again

- common/gaming: security wrapper for gamescope

- flake: bump inputs

- editors/neovim: use npins to manage out-of-tree plugins

- docs: update repo layout in the README

- flake: trigger mkdocs-linkcheck on markdown edits

- apps/schizofox: use the correct path for the startpage

- flake/pkgs: provide startpage as a package

- hosts/gaea: remove tabnine cmp

- flake: more pre-commit hooks

- gpu/nvidia: disable fine-grained power management by default

- hosts/gaea: proper neovim configuration

- hosts/gaea: switch from vim to neovim

- flake: bump inputs

- services/shared: kdeconnect in home-manager

- system/hardware: zenstates value config

- hosts/gaea: configure vim instance

- treewide: remove unused `_:` instances and minor cleanup

- terminal/foot: disable dpi-aware

looks funky on a lower DPI screen

- editors/neovim: move extraPluins out of defauşt.nix, use plugin builder

- flake: bump inputs

- gpu/nvidia: enable prime offload if hybrid

- Merge pull request #41 from NotAShelf/hardware-refactor

treewide: refactor hardware options
- hosts: rename deprecated enableInitrdTweaks

- treewide: refactor hardware options

- lib: cleanup

- system/hardware: clean up AMD cpu and gpu configurations

- roles/workstation: proxychains and tor

- terminal/foot: change padding

- services/ags: more utils to the new setup syntax

- hosts/icarus: switch type to "hybrid"

- services/ags: convert some of the connections to the new setup hooks

- flake: bump inputs

- core/secrets: abstract around secrets attrs

- system/security: disable apparmor on aarch64

marked as broken

- treewide: cleanup

- flake: remove nix-ld input

- editors/neovim: clean up config and add mappings

- terminal/kitty: please work

- system/fonts: monospace is the bane of my existance

- services/runners: use in-tree nix-ld module

- flake: bump inputs

- os/networking: security tweaks & documentation

- laptop/power: fully convert systemd service to nixos syntax

- terminal/emulators: make sure all terminal emulators use the correct font

- roles/laptop: convert HM systemd service format to nixos

- flake: bump inputs

- services/headscale: cleanup

- networking/tcpcrypt: enable only if device is not a server

- os/networking: enable tcpcrypt

seems fixed, but watch for future breakages

- os/networking: separate tcpcrypt

- docs/notes: update impermanence setup notes

- networking/tailscale: avoid sending logs

- os/services: refactor

- roles/workstation: drop redundant ld-link

- services/headscale: enable web frontend

- modules/power: refactor

- flake: bump inputs

- services/nextcloud: nextcloud27 -> nextcloud28

- services/networking: headscale worky

- firewall/fail2ban: increase max ban duration

- flake: bump inputs

- services/nextcloud: generate preview images periodically

- services/kanidm: init

- services/headscale: cleanup

- hosts/atlas: merge hardware configurations

- flake: bump inputs

- tools/xdg: uppercase, whoops

- lib: mkSdImage

- flake: bump inputs

- modules/core: tweak systemd configuration

- tools/xdg: use config to determine homeDir

- flake/modules: init transience

a home-impermanence alternative that cleans specific directories instead of wiping your home on boot

- flake: bump inputs

- flake: bump inputs

- services/ags: appLauncher is a function now

- wms/hyprland: handle brightness through ags

- services: move ags from shared to wayland

- media/mpd: disable beets

broken again

- flake: bump inputs

- flake: bump inputs

- roles/server: disable all documentation on servers

- security/kernel: document blacklisted filesystems

- os/programs: daemonize direnv

- os/services: specify fwupd EspLocation

- packages/gui: replace schildichat-desktop with element-desktop

- flake: bump inputs

- system/nix: set default registry only if we are using nix-super

- boot/generic: increase base tmpfs ssize

- security/sudo: try again to make passwordless rebuilds work

- games/minecraft: wrap prismlauncher with glfw

- services/ags: make weather widget consistent with the rest of the widget sizes

- services/ags: theming changes and weather icon

- docs: update desktop preview (2023-12-09)

- flake: bump inputs

- services/ags: fmt

- services/ags: allow ags to reload on rebuild

- services/ags: clean up usage widgets

- services/ags: CPU & RAM indicators and other stuff

- services/ags: wip circular system status indicators

- flake: bump inputs

- Merge pull request #39 from NotAShelf/dependabot/github_actions/easimon/maximize-build-space-10

build(deps): bump easimon/maximize-build-space from 9 to 10
- build(deps): bump easimon/maximize-build-space from 9 to 10

Bumps [easimon/maximize-build-space](https://github.com/easimon/maximize-build-space) from 9 to 10.
- [Release notes](https://github.com/easimon/maximize-build-space/releases)
- [Changelog](https://github.com/easimon/maximize-build-space/blob/master/CHANGELOG.md)
- [Commits](https://github.com/easimon/maximize-build-space/compare/v9...v10)

---
updated-dependencies:
- dependency-name: easimon/maximize-build-space
  dependency-type: direct:production
  update-type: version-update:semver-major
...

Signed-off-by: dependabot[bot] <support@github.com>
- services/mpd: organize relevant services and programs

- services/ags: more consistent padding and rounding

- hosts/enyo: mount music directory in the Media directory

- media/mpd: mpdris 2 bridge service

- flake: bump inputs

- services/ags: replace hyprctl-swallow with a bash script

- services/ags: filter source properly

- treewide: don't touch js files in .editorconfig integrations

- services/ags: change linting rules

- services/ags: attributions in README

- services/ags: linter configurations

- services/ags: handle potential null references and array bounds issues

- flake: bump inputs

- core/nix: transcend nixpkgs#271423

- terminal/shell: auto-run programs with nix-index

- services/ags: init stystem info module

- services/ags: remove redundant code, improve styling

- services/ags: return swallow status in the tooltip

- homes/notashelf: disable waybar

- services/ags: simplify style aggregator

- flake: update ags

- services/ags: make workspace indicators more obvious

- services/ags: working network indicator

- flake: bump inputs

- Merge pull request #38 from NotAShelf/ags

homes/notashelf: ags module
- services/ags: recolor

- services/ags: refactor again

- services/ags: bluetooth and audio icons

- services/ags: refactor structure

- services/ags: prepare for conditional batter widget

- services/ags: let the systemd service access video devices

- services/ags: have the swallow button trigger the correct program

- services/ags: catch tray fails

- services/ags: swallow indicator

- services/ags: init

- CI: fine-grain trigger paths

- flake: bump inputs

- CI: run forgejo workflows on ubuntu-latest

- flake: bump inputs

- CI: init foregejo workflows

- wms/hyprland: update configuration

- multimedia/sound: refactor

- flake: bump inputs

- flake: bump inputs

- monitoring/loki: expand config

- Merge pull request #37 from NotAShelf/dependabot/github_actions/cachix/cachix-action-13

build(deps): bump cachix/cachix-action from 12 to 13
- build(deps): bump cachix/cachix-action from 12 to 13

Bumps [cachix/cachix-action](https://github.com/cachix/cachix-action) from 12 to 13.
- [Release notes](https://github.com/cachix/cachix-action/releases)
- [Commits](https://github.com/cachix/cachix-action/compare/v12...v13)

---
updated-dependencies:
- dependency-name: cachix/cachix-action
  dependency-type: direct:production
  update-type: version-update:semver-major
...

Signed-off-by: dependabot[bot] <support@github.com>
- Merge pull request #36 from NotAShelf/dependabot/github_actions/easimon/maximize-build-space-9

build(deps): bump easimon/maximize-build-space from 8 to 9
- build(deps): bump easimon/maximize-build-space from 8 to 9

Bumps [easimon/maximize-build-space](https://github.com/easimon/maximize-build-space) from 8 to 9.
- [Release notes](https://github.com/easimon/maximize-build-space/releases)
- [Changelog](https://github.com/easimon/maximize-build-space/blob/master/CHANGELOG.md)
- [Commits](https://github.com/easimon/maximize-build-space/compare/v8...v9)

---
updated-dependencies:
- dependency-name: easimon/maximize-build-space
  dependency-type: direct:production
  update-type: version-update:semver-major
...

Signed-off-by: dependabot[bot] <support@github.com>
- programs/newsboat: update configuration

- services/monitoring: visualisation for endlessh-go metrics

- os/networking: ssh improvements

- flake: bump inputs

- editors/neovim: use my patched foot package in neovim desktop item

- flake: bump inputs

- flake: bump inputs

- system/activation: use nvd in rebuild diff

- services/harmonia: init

- modules: refactor

- modules/core: move ld-link to types/workstation

- system/os: rename network module to networking

- os/programs: syntax highlighting & vim keybinds for nano

- wms/hyprland: cleanup

- os/misc: init

- os/misc: realtime capabilities for mainUser

- os/misc: link standard linker if nix-ld is not enabled

- wms/hyprland: remove deprecated `enableNvidiaPatches` option

- flake: bump inputs

- treewide: xdg cleanup

- flake: bump inputs

- hosts/gaea: disable rebuild switches in live system

- hosts/apollon: switch kernels

- wms/sway: organize

- core/nix: t r a n s c e n d

- flake: bump inputs

- display/wayland: explicit portal configuration

- flake: bump inputs

- flake: bump inputs

- system/services: configure elasticsearch locally & enable by mastodon

- services/uptime-kuma: init

- services/mastodon: remove deprecated streamingPort

- flake: bump inputs

- services/postgresql: use new ensureDBOwnership option

- flake: bump inputs

- hosts/gaea: update configuration

- flake: bump inputs

- system/nix: more experimental features

most of those conflict with the current implementation of nix-direnv, the nix-direnv package NEEDS to be overriden if those features are set

- hardware/gpu: provide appropriate nvtop versions per gpu

- programs: override nix-direnv to use system nix derivation

- flake: bump inputs

- secrets: rekey with new host

- packages/wayland: write ocr script properly

- containers/alpha: cleanup

- services/waybar: use python 3.11 for weather indicator

- packages/gui: wrap Obsidian with pandoc

- flake: bump inputs

- treewide: start removing redundant `with lib;` instances

- flake: bump inputs

- docs: update security policy
- system/networking: tailscale cleanup

- flake: bump arrpc-flake

- os/services: earlyOOM for less significant applications

- networking/tailscale: don't enable client by default

- flake: bump inputs

- Merge pull request #35 from NotAShelf/containers


- network/tailscale: cleanup

- Merge pull request #34 from NotAShelf/containers


- system/containers: don't enable containers by default

- extra/containers: init module

- services/nftables: clean up DAG structure and inherits

please do not use this configuration, it is terrible

- services/waybar: inherit package from nixpkgs again

- services/postgresql: update to pgsql 15

holy fuck that was an adventure

- CI: check on all systems

- services/mastodon: patch package with bird-ui

- flake: update hyprland

- flake: bump nyxpkgs

- modules: decrypt secrets only if the relevant service is enabled

- services/atticd: init

- flake: bump inputs

- flake: bump inputs

- docs/notes: blog page on using headscale service

- hosts/helios: enable headscale service

- Merge pull request #33 from NotAShelf/headscale


- services/headscale: init

- services/nginx: www subdomain to the main domain

- services/nginx: alias www.domain to domain

- hosts/enyo: enable experimental nftables service

- homes/notashelf: remove overused `lib;` instances

- lib: make lib more schizophrenic

- flake: bump inputs

- flake: track nixpkgs-small

- system/security: allow disabling security mitigations

- services/mastodon: fine-grained nginx config

- flake: bump inputs

- hosts: update hosts overview

- network/firewall: init nftables

- network/firewall: initial work on nftables setup

- hosts/gaea: make iso efi/usb bootable

- system/security: init selinux module

- options/system: move old programs module options to the new one

- os/network: make wireless backend configurable

- treewide: remove no-op `lib.mdDoc` usage in modules

- server/services: nginx bullshit

- services/monitoring: clean up grafana data sources

- flake: bump inputs

- services/nextcloud: get rid of the opcache warnings

- apps/webcord: bump catppuccin theme version

- games/minecraft: replace nixpkgs prismlauncher with flake package

- flake: bump inputs

- flake: bump inputs

- flake: bump inputs

- programs/vifm: init draft home-manager module

- flake: bump inputs

- CI: drop flake update workflow

I prefer controlling when my flake gets updated, given how often nixpkgs breaks

- CI: don't build any packages

- treewide: move more packages to nyxpkgs

- hosts/erebus: use latest zfs compliant kernel

- CI: omit deprecated derivation

- treewide: use nyxpkgs binary cache

- flake: bump inputs

- services/reposilite: use the correct package

- Merge pull request #32 from NotAShelf/nyxpkgs


- treewide: replace noto-fonts-emoji with noto-fonts-color-emoji

- os/network: cleanup

- network/firewall: branch out and separate services

- treewide: move common packages to my personal overlay

https://github.com/notashelf/nyxpkgs now serves my shared packages as a standalone flake

- server/services: init tailscale server module

- Merge branch 'main' of github.com:NotAShelf/nyx

- os/services: increate zram memory percentage

- style: spaces between attrsets

- security/kernel: blacklist more obscure network protocols

seriously linux, fucking ATM?

- system/encryption: disable password timeout

- gpu/amd: clean up unused driver utilities

- system/activation: link user ssh config to root user

Nix build attempts to connect to the remote builders as the root user, for whatever reason, and fails when the keys are missing.
On activation, link my own user's ssh keys to the root user's ssh directory in order to allow for reliable remote builds.

- programs/git. more delta features

- flake: bump inputs

- treewide: replace noto-fonts-emoji with noto-fonts-color-emoji

- os/network: cleanup

- network/firewall: branch out and separate services

- services/postgresql: explicitly declare major version

For systems that have their stateVersion as `23.11`, postgresql is royally fucked because the data will not be migrated automagically. Solution? Set the major version to 14, build 15 locally and initialize a new database with version 15 to move the data over *manually*

- Merge branch 'main' of github.com:NotAShelf/nyx

- server/services: have services also enable their dependencies

- server/services: move nginx virtual host blocks to their individual services

- services/reposilite: extend nixos module

- flake: bump inputs

- whoops

- hosts/helios: enable reposilite

- services/postgresql: configure postgresql

- services/mastodon: explicit database configuration

- services/grafana: remove redundant postgresql section

- services/nextcloud: reorganize config

- flake: bump inputs

- pkgs/reposilite: provide mainPackage

- modules: reposilite nginx config

- editors/neovim: enable java language support

- modules/core: properly deprecate service override opts

- Merge pull request #31 from NotAShelf/refactor


- style: drop unused args

- homes/notashelf: place dev package sets into packages directory

- core/options: use mkRemovedOptionModule

- gpu/amd: mess around with drivers

- apps/steam: switch to overlays instead of package config

- flake: bump inputs

- CI: use DetSys nix installer

- modules: import reposilite service

- lib/aliass: init

- flake: clean up inputs

- systeme/os: cleanup

- os/environment: break into multiple sections

- modules/rpeosilite: init

- flake: bump inputs

- apps/spotify: rename deprecateed spicetify opts

- pkgs/reposilite: init at 3.4.10

- CI: cleanup

- Merge pull request #30 from NotAShelf/refactor

gaming/gamemode: isolate hyprland-specific script sections
- gaming/gamemode: isolate hyprland-specific script sections

- Merge pull request #24 from NotAShelf/refactor

complete refactor
- flake: cleanup

- lib: reorganize lib

- flake: bump inputs

- tools/services: disable udiskie until `#263500` is merged

- packages/gui: reorganize packages

- flake: bump inputs

- system/nix: permit insecure electron

- style: cleanup

- packages/gui: remove udiskie from packages

- style: cleanup

- apps/schizofox: move bookmarks under misc

- pkgs/mov-cli: replace python310Packages with python3Packages

- flake: bump flake inputs

- editors/neovim-flake: configure specs.nvim

- editors/neovim: readd harpoon

- flake: bump inputs

- securit/sudo: and again...

- security/sudo: again

- security/sudo: fall back to passwordless sudo

- security/sudo: try again to make passwordless rebuilds work

- flake: bump inputs

- wms/sway: make config more usable

- flake: make script formatting less inconsistent

- security/sudo: allow sudo to switch configurations

- system/virtualisation: change enable logic

- security/kernel: document lockKernelModules

- CI: name update step

- Merge branch 'refactor' of github.com:NotAShelf/nyx into refactor

- CI: finetune flake update workflow

- flake: bump flake inputs

- treewide: cleanup

- security/sudo: disable passwordless sudo

- flake: bump inputs

- flake: bump inputs

- flake: unpin neovim-flake branch

- terminal/foot: bring back opacity

- editors/neovim: enable highlight-undo

- hosts/apollon: drop unused services file

- terminal/foot: separate color presets

- homes/themes: nuke unrelated theme imports

- treewide: ignore age encrypted files in .editorconfig

- options/theme: separate theme list in its own file

- flake: bump inputs

- users/root: make root ssh key global

- hosts/helios: enable garage S3 backend

- shell/zsh: ignore redundant patterns in history

- system/secrets: make sure garage environment secret is accessible to the service

- services/garage: serve

- services/mastodon: redis

- treewide: let .editorconfig format bash scripts

- flake: bump inputs

- hosts: cleanup

- flake: bump inputs

- docs: relocate host definitions and specify host guidelines

- modules: switch places of core and common parent directories

- flake: rename devShell to shell

- hosts/apollon: init

apollon is a host primarily used for testing my servers, needs secrets shared

- hosts/artemis: change disk layout

- modules/common: init garage S3 service

- server/service: password protect redis

- shell/starship: prettify prompt

- flake: bump inputs

- modules/common: move server services from `config.services` to `config.system.services`

just as it was initially intended to be

- shell/starship: read a list of prompt elems from a separate file

- readme: try to center nix logo

- homees/notashelf: clean up `.local/bin` scripts

- homes/notashelf: separate development utilities

- services/mastodon: change web domain

- flake: bump inputs

- modules/options: get started with refactored programs module

- flake: disable remote builders in direnv

- os/environment: move nixos-specific aliases off of home-manager

- flake: cleanup

- flake: bump inputs

- editors/neovim: lua and bash support

- treewide: replace instances of "gitea" with "forgejo"

- flake: bump inputs

- boot/generic: sanitize kernel param lists

- wms/hyprland: tweak blur

- server/services: rework service options

- docs: prettify README

- flake: bump inputs

- flake: configure pre-commit hooks

- treewide: enable formatting checks & treefmt prettier module

- CI: don't accept flake config

- flake: bump inputs

- shell/starship: prettify prompt

- wms/hyprland: pass everything to dbus

- wms/hyprland: adapt to new breaking config changes

- launchers/anyrun: configure additional plugins

- system/nix: enable nixos documentation for anyrun-nixos-options

- security/kernel: avoid kernel memory address exposures

- docs: security policy

- flake: bump inputs

- flake: pre-commit hooks

- CI: give the update workflow better descriptions

- CI: give the update workflow better descriptions

- flake: bump inputs

- os/boot: make silent boot a toggle

- boot/generic: inherit `useTmpfs` from user config

- security/sudo: wrap the nixos-rebuild binary for sudo rules

- device/hardware: move old comments to module descriptions

- modules: refactor module structure, again

- programs/bat: convert to the new attrset source format

- wms/hyprland: rename deprecated systemdIntegration option

- flake: bump inputs

- flake: bump inputs

- hosts/gaea: cleanup

- modules/core: move security out of OS subdirectory

- os/neetwork: randomize scan and ethernet mac addresses

- media/sound: pipewire low latency

- pkgs/foot-transparent: 1.15.1 -> 1.15.3

- hosts/enyo: regenerate hardware config

- flake: bump inputs

- flake: cleanup

- Merge pull request #29 from NotAShelf/dependabot/github_actions/actions/checkout-4


- build(deps): bump actions/checkout from 3 to 4

Bumps [actions/checkout](https://github.com/actions/checkout) from 3 to 4.
- [Release notes](https://github.com/actions/checkout/releases)
- [Changelog](https://github.com/actions/checkout/blob/main/CHANGELOG.md)
- [Commits](https://github.com/actions/checkout/compare/v3...v4)

---
updated-dependencies:
- dependency-name: actions/checkout
  dependency-type: direct:production
  update-type: version-update:semver-major
...

Signed-off-by: dependabot[bot] <support@github.com>
- Merge pull request #27 from NotAShelf/dependabot/github_actions/easimon/maximize-build-space-8


- build(deps): bump easimon/maximize-build-space from 6 to 8

Bumps [easimon/maximize-build-space](https://github.com/easimon/maximize-build-space) from 6 to 8.
- [Release notes](https://github.com/easimon/maximize-build-space/releases)
- [Changelog](https://github.com/easimon/maximize-build-space/blob/master/CHANGELOG.md)
- [Commits](https://github.com/easimon/maximize-build-space/compare/v6...v8)

---
updated-dependencies:
- dependency-name: easimon/maximize-build-space
  dependency-type: direct:production
  update-type: version-update:semver-major
...

Signed-off-by: dependabot[bot] <support@github.com>
- Merge pull request #26 from NotAShelf/dependabot/github_actions/cachix/install-nix-action-23


- Merge branch 'refactor' into dependabot/github_actions/cachix/install-nix-action-23
- Merge pull request #28 from NotAShelf/dependabot/github_actions/actions/checkout-4


- build(deps): bump actions/checkout from 3 to 4

Bumps [actions/checkout](https://github.com/actions/checkout) from 3 to 4.
- [Release notes](https://github.com/actions/checkout/releases)
- [Changelog](https://github.com/actions/checkout/blob/main/CHANGELOG.md)
- [Commits](https://github.com/actions/checkout/compare/v3...v4)

---
updated-dependencies:
- dependency-name: actions/checkout
  dependency-type: direct:production
  update-type: version-update:semver-major
...

Signed-off-by: dependabot[bot] <support@github.com>
- flake: bump inputs

- build(deps): bump cachix/install-nix-action from 18 to 23

Bumps [cachix/install-nix-action](https://github.com/cachix/install-nix-action) from 18 to 23.
- [Release notes](https://github.com/cachix/install-nix-action/releases)
- [Commits](https://github.com/cachix/install-nix-action/compare/v18...v23)

---
updated-dependencies:
- dependency-name: cachix/install-nix-action
  dependency-type: direct:production
  update-type: version-update:semver-major
...

Signed-off-by: dependabot[bot] <support@github.com>
- programs/xdg-ninja: typo in config dir var

- CI: cleanup

- flake: rename parts/ to flake/ & modularize

- parts/pkgs: drop wl-clip-persist

- modules/core: improve core options

- flake: bump inputs

- editors/neovim-flake: enable lua language module

- flake: bump inputs

- hosts/artemis init

- games/minecraft: drop deprecated graalvm versions

- templates/c: bundle fucking everything

- types/workstation: enable ccache

- cpu/amd: load amd-pstate module unconditionally

- core/impermanence: make ccache directory permanent

- wms/hyprland: remove deprecated `multisample_edges` opt

- flake: bump inputs

- pkgs/wl-clip-persist: drop package in favor of nixpkgs

- hosts/erebus: cleanup

- flake: bump hyprland input

- apps/steam: wrap steam with more libraries

- modules: deprecate steam compat module in favor of the upstreamed nix-gaming one

- CI: accept flake config in check workflow

- os/security: clamav module

- services/miniflux: init

- tools/xdg: use Schizofox desktop file instead of Firefox

- editors/neovim: use system clipboard

- wms/hyprland: config cleanup

- flake: bump inputs

- CI: typo in fmt workflow

- os/environment: try to fix the MAILADDR bs

- flake: bump inputs

- CI: overhaul workflow name convention

- flake: bump inputs

- core/impermanence: passwordFile -> hashedPasswordFile

- core/nix: typo in nixos-test feature

- boot/generic: disable swraid by default

- modules/common: direnv cleanup

- hyprland: adapt to portal changes

- homes/notashelf: remove the xplr module that I upstreamed

- flake: bump flake inputs

- flake: pin schizofox to dev branch

- flake: bump flake inputs

- lib: actually rob @outfoxxed

:3

- lib: rob @outfoxxed

- cli/shared: clean up shared pkgs

- flake: bump inputs

- core/nix: drop gtklock overlay

- services/wayland: drop persistent workspaces

- terminal/shell: clean up zsh & replace exa

- tools/programs: replace exa with the fork, eza

- homes/notashelf: cleanup

- types/workstation: enable nix-ld

- flake: extend homeManagerModules schema

- flake: bump inputs

- flake: try out flake-schemas

- services/waybar: switch to waybar/workspaces

- tools/nix-index: typo in module name

- modules/workstation: move theming config to user home

- Merge pull request #25 from NotAShelf/themes


- treewide: move style configuration to user homes

- flake: use nix-index-database flake

- direnv: use nixos module

- flake: bump inputs

- hosts/enyo: follow kvantum config for qt apps

- parts/pkgs: bump ani-cli to 4.6

- flake: bump inputs

- apps/webcord: bump rev and hash

- hosts/enyo: reimport external mounts

- modules/emulation: do not try to emulate x86_64

Emulating current system (i.e aarch64 on an aarch64) breaks the boot sequence on unstable. Also see: https://github.com/NixOS/nixpkgs/issues/218465

- modules/emulation: do not mkForce aarch64 emulator

- modules/security: docs

- modules/system: use optionals for multiple warnings

- hosts/enyo: more security features

- flake: bump inputs

- modules/common: default lvm service to disabled

- modules/boot: correct attrset in the letin

- modules/device: separate devices module

- modules/renamed: usrEnv.autoLogin -> usrEnv.autologin

- modules/system: autologin -> autoLogin

- system/encryption: only warn about devices if LUKS encryption is enabled

- services/login: env.autologin -> sys.autoLogin

- tools/nix-shell: clear direnv stdlib

- flake: pin hyprland input

- hosts: conform to parent option changes

- modules/common: move autoLogin from usrEnv to system

- modules/system: detach emulation and encryption modules

- modules/theme: organize theming configuration per toolkit

- modules/device: separate options by theme

- modules/options: import renamed option imports

- docs: improve comments for usrEnv options

- modules/system: configuration interface for auditd

- docs: document yubikey related packages

- treewide: use mkRenamedOption for all system module options that are renamed

- modules/common: move secureBoot from system to security

- flake/lib: helper functions for device type and wayland capability checking

- modules/core: move yubikeySupport to `modules.system`

- flake: bump inputs

- homes: map home-manager configurations only if host declares home manager as enabled

- flake: bump inputs

- core/nix: remove duplicate overlay

- services/waybar: improve weather script

caching and other improvements

- present :)

- syntax

- core/nix: overlay gtklock

- programs/xdg-ninja: remove steam compat tools var from template

- apps/schizofox: clean up schizofox config

- flake: bump inputs

- hosts/enyo: cleanup

- flake: bump inputs

- flake: schizofox

- services/waybar: drop waybar-hyprland

- graphical/schizofox: remove old schizofox stuff

- graphical/schizofox: switch to standalone module

- hosts/hermes: enable gaming module

- flake: bump flake inputs

- flake: bump flake inputs

- flake: drop unused onedev module

- wms/hyprland: rename deprecated nvidiaPaths option

- parts/devShell: rename

- flake: bump inputs

- flake: re-implement flake templates

- flake: bump inputs

- modules/core: move network under OS

- boot/systemd-boot: allow memtest entry

- services/matrix: allow registration and disable statistics

- hosts/icarus: switch type to "lite"

- themes/qt: optionally enable kvantum and write config files to .config

- services/irc: deprecate

- services/monitoring: restructure

- wms/hyprland: try to make gropbars suck less

- flake: bump inputs

- hosts: update available style configurations

- programs/git: rename deprecated gh.gitCredientalHelper

- flake: bump inputs

- notashelf/themes: minor fixes

- hosts: replace deprecated username with mainUser

- apps/webcord: bump theme file rev

- services/grafana: change storage location

- notashelf/themes: use global theme options

- options/theme: more options for qt themes

- wayland/waybar: get waybar-hyprland from nixpkgs

- wayland/gtklock: cleanup

- flake: bump inputs

- modules: refactor structure

double down on the module format, except it makes a little more sense now

- modules/gamemode: hyprctl API changes

- services/gtklock: init

- hardware/laptop: more power saving options

- flake: bump inputs

- docs: correction

- parts/pkgs: bump mov-cli

- Merge pull request #21 from NotAShelf/gtklock-module


- flake: init gtklock module

- Merge pull request #18 from NotAShelf/theming-stuff


- treewide: better defaults

- hosts/hermes: declare style options explicitly under theming module

- hosts: clean up module definitions

- docs: typo in comments

- treewide: avoid types.string`

- services/waybar: why shadows no worky

- hardware/yubikey: drop irrelevant tools in favor of airtight host

- flake: bump inputs

- flake: bump inputs

- modules/desktop: move bandwhich to programs set

- modules/theme: kvantum enable opt

- Merge branch 'main' of github.com:NotAShelf/nyx into theming-stuff

- flake: bump inputs

- flake: bump inputs

- docs: conform to new docr post format

- launchers/anyrun: set prefix for symbols plugin

- Merge pull request #17 from NotAShelf/refactor-module-str


- treewide: nix syntax cleanup

- programs/flatpak: global flatpak directory

- modules/boot: inherit selected kernel properly

- hosts/enyo: xanmod kernel

- flake: bump inputs

- flake: bump inputs

- modules/system: cleanup

- modules/system: activation module

on-activation options for nixos or/and home-manager

- flake: bump inputs

- modules/profile: rename to profiles and move theming configuration

- modules: relocate display and cross-building modules

- lib/helpers: helper function for recursive list search

- terminal/foot: reasonable font size

- flake: bump flake inputs

- modules: refactor general module structure

- hosts/hermes: enable bluetooth

- editors/neovim: treesitter grammers

- wms/hyprland: conform to new blur changes

- core/nix: more experimental features

repl-flake and auto-allocate-uids

- apps/webcord: bump catppuccin theme version

- flake: bump inputs

- wms/hyprland: better shadows

- flake: bump flake inputs

- editors/neovim: nightly prep

- lib: cleanup

- flake: bump flake inputs

- editors/neovim: disable beacon.nvim

- flake: typos in comments

- editors/neovim: try to get nvimtree to behave

- editors/neovim: disable beacon for irrelevant filetypes

- editors/neovim: beacon.nvim and hypersonic

- editors/neovim: enable lsplines and lspkind

- flake: bump flake inputs

- flake: unpin neovim-flake branch

- editors/neovim: nvimtree configuration

- packages/gui: separate 3D printing packages

- flake: bump flake inputs

- editors/neovim: rename module and refactor


- editors/neovim: rename and refactor

- hosts/enyo: disable libreoffice override

- docs: relocate comments to sensible locations

- feat: bump flake inputs

- programs: choose wine package based on display server

- editors/neovim: clean up config

- wms/hyprland: disable default wallpapers

- flake: bump flake inputs

- treewide: rename deprecated font options

- editors/neovim-flake: use new extraPlugins option

- hosts: rename "profile" module to "profiles"

- system/network: allow hotpluggable network devices

Previously IP addresses were assigned to a device on boot rather than when they are plugged in. It held boot back when a wifi dongle was unplugged. With this, we should be able to hotplug them.

- system/fonts: rename deprecated defaultFontPackages option

- flake: bump flake inputs

- themes/gtk: default to dark gtk themes

- flake: bump inputs

- editors/neovim-flake: update configuration

- flake: bump inputs

- apps/schizofox: revert

- flake: bump inputs

- terminal/wezterm: clean up non-monospaced fonts

- flake: bump inputs

- parts/pkgs: correctly apply foot patch

- system/fonts: include FiraCode in fonts configuration

- parts/pkgs: update spotify-wrapped

- Merge pull request #15 from NotAShelf/native-hyprland-module

homes/notashelf: use the Hyprland module that got added to home-manager
- homes/notashelf: use the Hyprland module that got added to home-manager

It's severely fucked

- homes/notashelf: drop hyprland home-manager module from the flake

- parts/pkgs: transparency patch for foot

- flake: bump flake inputs

- terminal/wezterm: clean up and recolor

- core/impermanence: ssh keys in /persist

- themes/palettes: black metal theme

- apps/schizofox: cleanup navbar

- hosts/hermes: enable printing

- parts/pkgs: cleanup

- wms/hyprland: map workspaces to monitors through a function

- flake: bump inputs

- docs: update copyright notice for docs

- flake: bump inputs

- hardware/tpm: disable pkcs11 until python package is fixed

- flake: unpin neovim-flake input

- docs: include LICENSE

- flake: bump inputs

- treewide: remove references to the deprecated `system-module` branch

- Merge pull request #14 from NotAShelf/system-module

system module
- Merge remote-tracking branch 'origin/main' into system-module

- feat: update flake

- CI: trigger installation media builder less often

- CI: trigger blog action when the workflow is edited

- docs: update website settings

- CI: untar properly

- CI: drop apt invocation

- CI: drop GITHUB and ACCESS tokens in cachix workflow

- CI: use updated docr releases

- docs: update copyright notice

- display/xorg: enable i3wm if desktop is set to i3

- flake: bump inputs

- services/waybar: let workspaces function on a multimon setup

- docs: notes on distributed nix builds with a non-standard ssh port

- services/waybar: set all-outputs

- network/ssh: change default port and configure builders

- hosts/helios: disable smartd

- flake: bump inputs

- os/environment: remove doas

- modules/server: disable broken `noXlibs` module

- docs: reflect new module structure in README

- homes/notashelf: more multimonitor prep

- notashelf/packages: move server packages under the cli dir

- lib: adaquately separate lib functions

- modules/shared: import shared hm modules

- os/environment: import locale settings

- modules: move xplr module to home-manager

- flake: bump inputs

- xorg/wms: init i3

- services/login: try to re-add manual login sessions

- parts/pkgs: update mov-cli

- wms/hyprland: change screenshot binds

- flake: bump inputs

- docs: cleanup

- hosts: disable VMs

- modules/common: refactor

- hossts/enyo: multimonitor preparations

- modules/common: move network module to system from core

- flake: bump inputs

- modules/fs: autoSrub / btrfs subvolume if btrfs is supported

- modules/core: impermanence module

- flake: bump inputs

- Merge pull request #13 from n3oney/patch-1

wms/hyprland: automatically paste in propaganda
- bring back notification
- automatically paste in propaganda
- modules/impermanence: init

- hosts/erebus: separate yubikey toolchain

- home: init xplr module

- treewide: format yml files as yaml files are formatted

- modules/shared: clean up xplr module

- flake: bump inputs

- modules/shared: init xplr module

- modules/boot: make plymouth theme optional

- hosts/enyo: enable plymouth

- CI: clean up bad indentation
- Merge pull request #12 from NotAShelf/refactor-module-directory

Refactor module directory, again
-  modules/boot: enable plymouth conditionally

- flake/pkgs: rename plymouth theme package

- CI: have build workflow also build and cache airtight recovery media

- core/system: disable dirty tree check

- treewide: do not ignore git artifacts

- modules: refactor and restructure

- flake: rename home to homes and improve import

- docs: more comments

- hosts: move home back to its original place

- home/terminal: disable helix indefinitely

- home: drop unused editors

- core/network: default networkmanager plugins to none

- home/themes: disable qt packages for headless environments

- home/themes: disable qt packages for headless environments

- home/shell: lint extract script

- modules/desktop: enable firejail

- lib: separate validator functions

- CI: rename workflows

- docs: reflect new module structure in README

- flake: account for structure changes

- flake: move home module into modules directory

- flake: divide lib into multiple sections

- flake: restructure flake

- services/runners enable nix-ld again

- lib/nixpkgs: function to fetch user keys from github

- hosts/helios: grow boot partition only if systemd in stage1 is not enabled

- CI: build and cache recovery image

- hosts/helios: do not repeat boot twice

- hosts/enyo: invalid fix wireguard endpoint

- flake: bump inputs

- modules: virtualization module option for waydroid

- flake: import devShell env

- modules/server: systemd configuration

- core/network: adapt for better server use

- hosts/helios: grow boot partition when necessary

- home/zsh: drop unused plugin call

- flake: do not import templates until the rewrite

- launchers/rofi: define missing `sys`

- lib/nixpkgs: document extend nixpkgs options

- home/launchers: update enable conditions to require `sys.video.enable`

- flake: drop outdated templates to be rewritten later

- core/system: obtain revision from self properly

- docs: reflect new module structure in README

- ignore git artifacts

- core/system: refuse to build from a dirty Git tree

- core/security: configure sudo

- core/network: do not wait for individual interfaces

- flake: do not pin hyprland input

- home: cleanup

- modules/common: clean up modules

- flake: bump inputs

- treewide: refactor module names and locations

- flake: bump inputs

- services/runner: comment out specified libraries

- hosts/enyo: enable ratbagd for gaming mice customization

- home: disable beets module

- flake: bump inputs

- services/media: separate beets module

- services/runners: get nix-ld from the flake

- flake: bump flake inputs

- typo

- flake: bump flake inputs

- core/network: do not mess with hosts file on servers

- modules: separate options as a module

- hosts/hermes: services.lvm.enable needs to be force enabled

- CI: cleanup

- Merge pull request #7 from NotAShelf/simplify-flake-args

simplify flake args
- treewide: use withSystem self & inputs, remove unnecessary args

- flake: simplify structure and args

- home/foot: notifs

- hosts/hermes: LUKS requires `services.lvm.enable`

- modules/server: disable xlibs for servers

- modules/desktop: set i686-linux interpreter

- services/mpd: drop spek package

- services/dunst: alter size

- hosts/hermes: enable emulation

- flake: bump flake inputs

- modules/shared: init onedev module

- hosts/enyo: disable dhcp for primary interface

- shell/bin: update extract script

- home: enable manpages for home-manager

- core/nix: generate manpage caches

- system/services: enable smartd service, disable lvm service

- launchers/anyrun: expect sys.video to be enabled before enabling anyrun

- docs: init yubikey notes

- tools/git: gh extensions

- treewide: extend .editorconfig

- tools/xdg: more mimetype handlers

- home/zsh: `enableSyntaxHighlighting` -> `syntaxHighlighting.enable`

- home/packages: clean up packages

- launchers/anyrun: use the home-manager module

- flake: bump inputs

- flake: expose shared nixos modules

- services/polkit: switch to pantheon polkit

- lib: restructure

- flake: bump inputs

- services/nix-index: write to bin instead of shell script

- programs/nix-index: change download url for wget

- programs/bat: separate module

- flake: do not pin hyprland nixpkgs

- flake: bump inputs

- dev: test note-viewer CI

- secrets: update vaultwarden env

- flake: bump inputs

- apps/schizofox: use my searxng instance

- Merge pull request #4 from NotAShelf/services/searxng

server/services: set up searxng
- server/services: set up searxng

- programs/xdg-ninja: banish dotnet dir to XDG_DATA_HOME

- core/network: pass ssh ports to nftables filter

- core/network: switch to systemd-networkdw

- tools/nix-shell: set direnv layout cache

- flake: move direnv var to lib/flake

- core/services: automatically clean up audit.log

- flake: clean up devshell

- flake: finalize deadnix configuration

- style: stylua via treefmt

- style: formatting via deadnix

- system/security: make polkit logging verbose

- server/services: drop mkm

- dev: criu for virtualization module

- services/misc: alternative dbus implementation

- tools/git: use hm module for programs.gh

- flake: treefmt setup

- flake: drop mkm input

- treewide: editorconfig setup

- docs: notes on nextjs webapps

- services/tor: implement enable condition

- core/nix: preserve current flake in /etc

- style: drop dead nix code

- packages/gui: wrap gnome-control--center with `XDG_CURRENT_SYSTEM`

- packages/cli: move pamixer to desktop cli packages

- services/nextcloud: bump version

- flake: bump inputs

- flake: bump inputs

- hosts/epimetheus: force intel performance state to not suck

- pkgs: bump mov-cli version

- treewide: interpret .age files as binary on git

- flake: bump inputs

- home/graphical: standalone thunderbird module

- flake: bump inputs

Signed-off-by: NotAShelf <itsashelf@gmail.com>

- hosts: WIP airgapped VM/ISO host

- hosts/enyo: switch to new gpg keychain

- flake: bump inputs

- secrets: update vaultwarden env

- hosts/enyo: switch git signing key

- home: refactor home-only shell and terminal configurations

- Merge pull request #3 from NotAShelf/profiles/bootloader

boot: refactor bootloader module
- boot: refactor bootloader module

- secrets: rekey

- hosts/icarus: adapt for the new system structure

- hosts/gaea: revoke unused ssh keys in installer

- hosts/icarus: we don't need that many drivers

- flake: bump inputs

- CI: do not validate before cache builds

- CI: stuff

- CI: get private access token from env

- CI: build from system-module branch

- hosts/gaea: provide nixos-install-tools in packages

- style: drop unused args

- flake: bump inputs

- CI: build more system packages in matrix strategy

- pkgs: package horizontally spinning rat

- modules/system: move graphic benchmarking tools to video module

- core/nix: limit TCP connections during fetch

- flake: provide a cached package for Hyprland w/ nixpkgs override

- CI: rewrite binary cache workflow

- flake: unpin hyprland input

- flake: bump flake inputs

- CI: build from system-module branch

- CI: push binaries to the correct cache

- flake: bump inputs

- flake: cache hyprland builds on my cachix

- flake: bump inputs

- modules/hardware: clean up hardware modules

- services/grafana: change service addr

- wms/hyprland: get hyprland tools from flake outputs

- flake: bump inputs

- qt: get themes and icons from qt5ct

- pkgs/waycorner: drop

- network/blocker: unblock social apps

- flake: bump inputs

- core/nix: gc and optimise builds on unused hours

- services/login: unlock gnupg on login

- network/firewall: drop qb port

- neovim-flake: switch to clangd

- home/packages: move packages to correct categories

- stuff

- flake: bump inputs

- stuff

- flake: bump inputs

- services/mailserver: webmail config

- services/mailserver/roundcube: roundcube plugins

- secrets: update

- secrets: hashing

- secrets: sanitize

- secrets: escape

- secrets: update env

- services/vaultwarden: reset admin token

- services/vaultwarden: enable admin page

- services/vaultwarden: force create backupDir

- services/vaultwarden: update backupDir

- services/vaultwarden: rename dataDir

- services/vaultwarden: force SSL/TLS

- secrets/mkm-web: update

- services/mkm-web: get env from correct path

- secrets: perms for mkm-web secret

- secrets/mkm-web: sanitize

- flake: bump inputs

- flake: bump inputs

- flake: bump inputs

- services/mkm: read environment from file

- flake: bump inputs

- services/mkm: change ports

- services/vaultwarden: relocate vaultwarden state dir

- services/vaultwarden: configure mailer settings

- modules/extra/server: extend nextcloud config

- whoops

- services/nextcloud: connect to redis socket for caching

- flake: bump inputs

- core/secrets: service secrets are owned by service users

- services/mailserver: switch sieve directory to storage volume

- treewide: clean-up service configs

- hosts/helios: storage volume

- services/nginx: proxy roundcube

- treewide: clean up secret paths

- services/mailserver: move postfix to services

- flake: bump inputs

- dev: per-service mailers

- flake: bump inputs

- hosts/hermes: allow tailscale

- apps/spotify: more spicetify extensions

- core/security: wheel does not need password

- core: drop ubuntu builder

- modules/mailserver: webmail

- services/waybar: clean up waybar theme

- docs: update desktop preview

- flake: bump inputs

- hosts: use lib to merge lists

- services/waybar: clean up waybar theme

- docs: notes on extended `nixpkgs.lib`

- home: clean up fonts

- system: switch builder key

- home/foot: still broken

- neovim-flake: custom plugin work

- modules: cleanup

- dunst: resize

- pkgs: package waycorner & bump ani-cli

- flake: bump inputs

- modules/boot/loaders: cleanup

- hosts: cleanup

- lib: simple boolToInt functions

- docs: relocate readme

- home: use profile for waybar theming

- treewide: finalize profile structure

- pkgs: update ani-cli version

- apps/libreoffice: switch to new override service

- modules/programs: seperate programs and services

- modules/wayland: cleanup

- services/waybar: update waybar style

- flake: bump inputs

- apps/schizofox: drop schizo options

- services/mongodb: re-disable

- core/nix: allow unsupported system

- services/mongodb: re-enable

- modules/core: cleanup

- flake: bump inputs

- services/mkm: read environment secrets from secrets file

- boot/loaders: do not share kvm-intel module between hosts

- treewide: ignore VM artifacts

- services/mkm: get docker image file from flake input

- modules/virtualization: enable dns for podman-to-podman communication

- services/mkm: clean up oci container

- hosts/helios: kvm kernel module

- packages/cli: drop docker CLI packages

- flake: bump inputs

- notes: update ephemeral root instructions

- flake: allow pulling from private repositories in github actions

- services/mkm: virtualize

- flake: get mkm from repo

- hosts/helios: allow helios to use docker

- dev: gt nix-shell from nix package

- dev: mkm uses nix shell

- dev: reload mkm on rebuild

- dev: not allowed to use user services

- dev: mkm systemd service

- flake: refactor flake lib location

- terminal/shell/ssh: drop unused port

- treewide: refactor module system

- flake: bump inputs

- hosts/enyo: allow docker

- modules/server: mkm nginx configuration

- modules/server: allow mkm through firewall

- shell/ssh: update host details

- treewide: ignore build-vm artifacts

- modules/server: cleanup

- services/database/mongodb: disable

- server/services: enable mysql database

- services/login: greetd non-autologin config

- system/environment: flake path as an environment variable

- modules/core: move tailscale module to network

- programs/cli: nh nix helper

- hosts: separate VM hosts

- system/nix: anyrun binary cache

- server/security: drop unused openssh opts

- database/mysql: mkm db

- network/ssh: update openssh configuration options for 23.05

- flake: bump inputs

- hosts/hermes: init

- laptop/power: mkDefault autofreq frequencies

- services/login: provide tuigreet config

- apps/webcord: provide webcord config in the repository

- games/minecraft: wrap prismlauncher with java versions

- hardware/laptop: tweak default cpu frequencies

- flake: follow flake inputs in helix

- apps/zathura: get zathura colors from catppuccin repository

- flake/flake-parts: allow unsupportedSystem in perSystem pkgs

- flake/pkgs: update discordo

- treewide: switch to flake-parts

- wms/hyprland: clean up screenshot binds

- flake: drop unused flake checks

- flake: drop unused flake checks

- hosts/epimetheus: enable nvidia drivers again

- editors/helix: try to fix font overlapping

- flake: bump flake inputs

- dev: clean-up project templates

- home/shell: dirty C compile helper

- server/services: clean-up mailserver configurations

- neovim-flake: change filetree keybind

- server/services: configure mailserver properly

- core/network: clean-up firewall ports

- home/zsh: better fbin alias

- flake: bump inputs

- system: update mailserver secret

- core: refactor and centralize secrets

- home/apps: spotify+spicetify

- hosts/epimetheus: hyprland cleanup

- home/schizofox: conform to module changes

- home: refactor home-manager module

- home/wms/i3: clean-up config

- home/schizofox: refactor module

- pkgs/overlays: drop chromium override

- flake: bump inputs

- server/services: new databases layout

- core/nix: clean-up builders config

- hosts/enyo:  return to systemd-boot

- treewide: cleanup

- home/themes/qt: use dark theme for calibre

- ssh: clean up ssh hosts

- flake: unpin nix-super

- flake: bump inputs

- server/services: mongodb module

- flake: bump inputs

- flake: do not pin hyprland nixpkgs

- flake: bump inputs

- treewide: clean-up nix syntax

- server/services: enable gitea service

- style: alejandra

- style: alejandra

- services/matrix: allow federation port through the firewall

- Revert "services/matrix: allow federation port through the firewall"

This reverts commit 5904aa6ccf50742e08eacd1bebb3ee86cd6c45e6.

- services/matrix: allow federation port through the firewall

- services/matrix: update homeserver fqdn

- hosts/helios: use the correct secret for mailserver

- server/services: open necessary ports

- server/services: mailserver module

- services/nextcloud: use the correct secret

- hosts/helios: move to new hardware

- hosts/helios: switch to new machine

- system/secrets: conform to new agenix format

- system: hash the rest of the secrets

- flake: bump inputs

- system: drop sops-nix

- core/secrets: update nix builder key mode

- treewide: replace ragenix with agenix

- home/themes/qt: drop qt5ct

- home/services/shared: use systemd user services for nextcloud

- home/hyprland: run rofi as service

- flake: bump inputs

- core/system: refactor nix builders module

- desktop/programs: receive proton-ge from nix-gaming

- core: move defaultPackages to core/system/environment

- core/nix: clean-up nix configurations

- core: clean-up nix package manager configurations

- home/rofi: clean-up rofi config

- flake: bump inputs

- pkgs: drop unused flake output packages

- home/packages/wayland: drop shadower

- flake: bump inputs

- home: import common fake tray service

- hosts/epimetheus: allow virtualization via qemu

- core/nix: get unstable nix from nixpkgs

- core/system: VISUAL and PAGER vars

- lib: cleanup

- hosts/epimetheus: disable nvidiaPersistenced

- hosts/gaea: declutter installer ISO

- system: centralize qt themes

- home/zsh: declutter zsh init

- apps/webcord: update catppuccin theme

- home/gaming: separate minecraft module

- flake: pin nix to master branch

- flake: bump inputs

- hosts/epimetheus: useDHPC by default

- gamemode: switch hyprctl commands

- hosts/enyo: xanmod kernel

- flake: bump inputs

- hosts/apollon: force 32bit dri support off

- home/chromium: initial groundwork

- flake: bump inputs

- home/packages: disappoint stallman

- pkgs: drop chromium from overlays

- home/webcord: update catppuccin theme

- flake: bump inputs

- enyo: allow emulation

- neovim-flake: editorconfig support

- home: refactor services

- system: drop unused architechtures

- style: formatting

- hosts: refactor VM hosts

- VDPAU_DRIVER on intel-only

- flake: bump flake inputs

- xplr: import plugins

- treewide: cleanup

- flake: drop nix-on-droid inputs

- nvidia: **fuck** nvidia

- wayland: drop useless nvidia variables

- modules/desktop/cross

emulation: allow aarch64 and i686 systems

- nix: allow nix to build cross-system

- epimetheus: allow cross-system emulation

- neovim-flake: use vim-wakatime branch

- flake: bump flake inputs

- system: server services and service overrides

- kernel: no longer silent

- flake: bump inputs

- pkgs: update proton-ge version

- flake: bump inputs

- hyprland: propaganda keybind

- starship: place `@` before the hostname in ssh

- hyprland: special workspace keybinds

- rofi: replace old nerdfonts icon

- docs: remove usage instructions

- neovim-flake: use experimental v4 branch

- flake: bump flake inputs

- nvidia: tweak envvars

- arRPC: use arrpc home-manager module

- pkgs: fastfetch `1.10.3` -> `1.11.0`

- style: formatting

- pkgs: update proton-ge version

- flake: bump inputs

- flake: get wallpkgs from the flake

- hyprpaper: get wallpaper from my wallpkgs

- desktop: get nerdfonts from nixpkgs again

- zsh: remove bat cache from rebuild command

- home: cleanup

- home: cleanup

- waybar: hotfix for changed nerdfonts

- flake: deprecate pinned nixpkgs

- flake: bump inputs

- flake: bump inputs

- desktop: receive nerdfonts from pinned nixpkgs input

- shell: use catppuccin-mocha bat theme

- flake: bump inputs

- flake: provide pinned nixpkgs for broken nerdfonts

- home: get helix from external flake

- core: tailscale firewall requirement

- home: clean-up zsh init

- flake: bump inputs

- hyprland: clean-up config

- boot/loader: force max resolution for systemd-boot

- home: clean-up shell configurations

- flake: document flake attributes

- ssh: commonIdFile

- shell: move git and tarnsient-services into tools/

- shell: move git and tarnsient-services into tools/

- home: make kitty support in ranger optional

- waybar: correct font colors for the CPU module

- wayland: waybar styling

- wayland: improve suspend logic

- wayland: clean-up swayidle artifacts in swaylock module

- home: clean-up mpd options

- home: separate minecraft from gaming/games

- flake: bump inputs

- linus: fuck nvidia.

- apps: use nix-colors variables for zathura

- apps: disable mpv osc

- network: use systemd-resolved for networkmanager dns

- wayland: separate sway module and config

- flake: remove unused flake inputs

- flake: bump flake inputs

- home: refactor services

- ssh: use correct port

- security: disable kernel module locking

- docs: explain sdhci module

- epimetheus: use DHCP per interface

- hyprland: gaps_out 12 -> 11

- flake: import templates from the correct directory

- flake: bump flake inputs

- flake: import flake templates

- home: auto-start fake tray application

- flake: bump flake inputs

- dev: project templates

- bootloader: display plymouth animations on suspend hooks

- network: start ssh when needed

- hardware: refactor types/laptop

- flake: bump flake inputs

- hardware: conform to gpu module options

- lib: `mkNixosSystem` for easy host creation

- hyprpaper: map available monitors in the config file

- wireguard: rename network interface

- dev: clean-up ssh hosts

- style: formatting

- docs: remove comment

- dev: refactor wireguard module

- docs: remove comment

- ragenix: rekey secrets

- ragenix: set up per-host keys

- flake: bump inputs

- style: formatting

- dev: fuck around and find out

- dev: switch to testing interface on wireguard

- dev: testing interface for wireguard

- wireguard: always restart wg-quick service

- wireguard: refactor modules

- ragenix: use correct secret attribute

- wireguard: use agenix secrets path for privateKeyPath

- wireguard: change keypair paths

- wireguard: use correct endpoints

- firewall: clean-up open ports

- wireguard: update listen port

- wireguard: update privateKey path

- core: move fail2ban to network

- core: temporarily disable firewall

- home: restrict mpd to non-server machines

- dev: try out wg-quick

- theme: force proper GTK and QT themes

- security: enable UserNamespaces

- core: open tailscale port by default

- flake: bump inputs

- modules: move theming variables off of wayland module

- pkgs: deprecate catppuccin derivations in favor of nixpkgs packages

- lib: move service helper function to common library

- home: separate wallpaper services

- pkgs: update proton-ge

- feat: cleanup

- feat: bump flake inputs

- dev: remove deprecated packages

- dev: change programs.chess to programs.chess.enable

- feat: bump flake inputs

- feat(atlas): disable grub on Pi4

- feat: systemd service for persistend wayland clipboard

- feat: bump flake inputs

- feat: follow nixpkgs on more inputs

- feat(atlas): move config abstractions to new format

- feat(pkgs): update webcord-vencord hash

- feat: bump flake inputs

- feat: make fzf background transparent

- feat: bump flake inputs

- feaT: pin hyprland input

- Merge pull request #2 from Amanse/system-module

Show details of nyx repo in README
- Show details of nyx repo in README

Update the links from using dotfiles repo to nyx repo
- feat: use custom lib function to optionally append groups

- dev: test custom ifTheyExist function

- feat(virt): spiceUSBRedirection

- feat: update FZF colors

- feat: arRPC systemd unit

- feat: bump flake inputs

- feat: move built iso images to hosts/

- feat(pkgs): move python requests package to desktop

- feat: expose a pipe at /tmp for ncmpcpp visualiser

- feat: append certain groups only if they exist

- feat: update desktop preview

- feat: wireguard cleanup

- feat(enyo): default useDHCP to false

- feat: move all networking opts to networking module

- dev: mess around with subnets more

- dev: move wg client ips around

- dev: follow archwiki instead of nixos.wiki

- feat(pkgs): arRPC in flake outputs

- feat(ssh): use correct private keys

- style: cleanup

- feat: allow 0.0.0.0/0, ::/0

- feat: wireguard client

- feat: rekey secrets

- feat: finalize wireguard setup for server

- feat: update helios host

- feat: refactor wireguard

- feat: even more host cleanup

- feat: more host cleanup

- feat: disable nftables

- style: formatting

- feat: clean up services

- feat: always import services

- feat: disable server services by default

- feat: define hostname for helios

- style: formatting

- feat: services are conditionally enabled

- feat: conditionally import texlive

- feat: conditionally configure gtk

- feat: clean up home-manager exports

- feat: update helios configuration

- feat(packages): clean up home-manager imports

- feat(helios): new hardware for helios

- feat: bump flake inputs

- feat: cleanup

- feat: update ssh keys

- feat: move users to impermanence module

- feat: more conditional package imports

- feat: rework CLI programs interface

- style: formatting

- feat(server): wireguard module

- feat: allow null in device components

- feat: move programs.zsh to core

- docs: update TODO

- feat(helios): conform to standard host format

- feat: encrypt wireguard secret

- feat: init profiles system

- feat(helios): new hosts

- feat: permitCertUid for tailscale

- feat: package wl-clip-persist for nix

- feat: move arrpc to overlays

- feat: podman replaces docker

- feat: bump flake inputs

- feat(neovim-flake): make neovim transparent again

- feat: bump flake inputs

- feat: update webcord-vencord

- feat(neovim-flake): adapt for 0.9.0 hotfix

- feat: bump flake inputs

- dev: do not import cnvim module

- docs: comments

- feat(flake.nix): cleanup

- feat: allow electron21 insecure package

- feat: bump flake inputs

- feat(env): remove nixpkgs neovim from system packages

- feat: re-add nixpkgs-wayland overlay

- feat(pkgs): structure refactor

- feat(wayland): drop irrelevant WLR envvars

- feat(boot/loaders): account for the new tmp attrset

- feat: use waybar-hyprland from hyprland input

- feat: switch diffoscope with diffoscopeMinimal

- feat: pin hyprland revision

- docs: update completed TODO items

- feat(hyprland): blur ignores below windows

- feat(pkgs): package arRPC for self-overlay

- feat(terminal): refactor shell programs and tools

- feat(hyprland): remove steam windowrules

- dev: rename shell env

- feat(hyprland): change common keybinds

- style: formatting

- feat: webcord-vencord package

- dev: separate packages to be moved

- style: formatting

- feat: secureboot module & bootloader refactor

- feat: refactor boot module

- feat: drop helix flake

- feat(hyprland): keys enable dpms

- docs: complete March 14th notes for disk encryption and impermanence

- feat: drop helix flake

- feat: bump flake inputs

- feat: bump flake inputs

- feat: try to use remote builders where available

- feat: bump flake inputs

- dev: remove emacs, stupid editor

- feat: bump flake inputs

- feat: bump flake inputs

- feat: move xdg portal out of flatpak module

- feat: bump flake inputs

- feat: update neovim config

- feat: re-add xdg-desktop-portal-hyprland manually

- feat: bump flake inputs

- dev: try to add Nextcloud to kvantum managed apps

- feat: update proton-ge

- dev(epimetheus): home-manager wants legacy on laptop

- feat(hyprland): map monitors list to individual entries

- feat: bump flake inputs

- feat(hyprland): map monitors list to individual entries

- feat(home-manager): laptop crashes if startServices is sd-switch

- feat: bump flake inputs

- dev: cleanup

- dev: indev wireguard module (no worky)

- feat: improve newsboat config

- feat: switch to main branch of neovim-flake

- feat: bump flake inputs

- dev(pkgs): work on packaging shadower

- feat: bump flake inputs

- style: formatting

- feat(zsh): more vim-mode binds

- style: cleanup

- style: cleanup

- dev: misc services directory

- dev: groundwork for hm managed ssh

- feat: mpd discord rpc & yams

- feat: re-enable vscode

- dev(tofi): attempt to increase left margin

- feat: switch to my own neovim-flake

- feat: bump flake inputs

- feat(home): start nextcloud-client service in the background

- feat(server): move domain names into letins

- feat(server): nextcloud service

- dev: don't persist adjtime

- feat(neovim-flake): inputs follow nixpkgs

- feat: theme more windows

- feat: remove hyprland portal from flake inputs

- feat: implement `notashelf/neovim-flake` in my system flake

- feat: bump flake inputs

- style: cleanup

- dev: import my neovim-flake to test

- feat: bump flake inputs

- feat: bump flake inputs

- dev: groundwork on secureboot

- feat(core): set up remote builders

- feat(enyo): disable bluetooth

- feat(home): return to "sd-switch"

- feat: bump flake inputs

- feat(janus): force firewall off in virtual machines

- dev: remove dated warning

- feat(system): cleanup

- dev: re-disable obscure kernel modules

- feat(env): conditional doas alias

- dev: groundwork on remote builders

- feat: persist secureboot and sudo db

- feat: cleanup zsh aliases and handlers

- dev: remove nix-index section

- feat(waybar): import bluetooth module only if bluetooth is enabled

- dev: groundwork for sops-nix

- feat: enable comma

- dev: move steam module to nixos modules

- feat(gaea): break the installation iso into multiple files

- dev: groundwork for sops-nix

- feat: move type module to hardware

- feat: nixos modules

- feat: clean up virtualization module

- feat: bump flake inputs

- feat: remove fractal

- feat: bump flake inputs

- feat: bump flake inputs

- dev: groundwork on mangohud config

- feat: clean up flake inputs

- dev(services): import runners

- feat: bump flake inputs

- feat: remove obsidian from system overlays

- feat: remove swww from system overlay

- feat: move anime4k to overlays

- feat(bat): use `less -FR` as pager

- feat: bump flake inputs

- dev: possibly fix direnv cache location?

- feat(home/gaming): re-add gamescope as wlroots is fixed

- dev(schizofox): use mkMerge for layered security opts

- feat: bump flake inputs

- dev: formatter leave me alone

- dev: move overlay lib functions to extended nixpgks lib

- dev: initial work on system profiles

- feat(desktop): separate gaming and chess logic

- feat(epimetheus): import users module

- dev: remove elixir_ls

- feat: unpin hyprland rev

- feat: update flake inputs

- feat(epimetheus): load webcam kernel module

- feat: update flake inputs

- dev(grub): reset theme package to `null`

- feat(pkgs): update ani-cli

- feat: update flake inputs

- feat(misc): disable extra systemd tty

- style(cross): nix syntax

- feat: configure more locale settings

- docs(gaea): more comments

- feat(enyo): declarative mounts

- feat(runners): run non-nix software easily

- feat(tpm): saner defaults

- feat: update proton-ge and swww

- feat: update flake inputs

- feat(newsboat): new colors

- feat(schizofox): layered security options

- feat: regular systems should be mutable, encrypted should not

- feat(enyo): re-structure for new hardware

- feat: pin hyprland commit

- feat: update flake inputs

- feat: move tcp configuration to system module

- dev: let cfg -> video

- dev: systemd-boot should show ALL gens

- feat: clean up ssh and networking

- feat: update flake

- feat: update flake

- feat: conform to new system-module structure

- feat: update waybar style

- feat: merge networking modules

- feat: clean up user passwords

- feat: move greetd and login keyring unlock to login module

- feat: clean up login module

- feat(enyo): system should autologin

- feat: update webcord css

- dev: remove /var/lib/networkmanager

- syntax: cleaner nix

- feat: more nix shortcuts

- feat: decrypt disk before LVM

- feat: update flake

- docs: update README

- feat: cleaup

- feat: remove polkit service to its own module

- feat: update flake

- feat(home-manager): fall back to legacy version of sd-switch

- feat: set up flake checks

- feat: turn on extraSecurity for schizofox

- feat: make users immutable

- feat: clean up laptop module

- style: markdown formatting

- feat: configure root user

- feat: slim down rescue iso

- feat: clean up common bootloader

- feat: auto-set backlight on start

- feat: disable devshell

- feat: separate disk encryption from ephemeral root

- feat: update flake

- feat: update impermanence setup

- style: formatting

- feat: configure base root user

- feat: gnome polkit agent

- feat: update flake

- dev: try to make keyring work

- feat: passwordfile to be used on encrypted hosts

- feat: encrypted brother host to prometheus

- feat: impermanence

- feat: update flake

- dev: experimental encrypted reiteration of prometheus

- feat: cleanup

- feat: update todo

- style: nix syntax

- feat: new modules for waybar

- dev: starship prompt

- feat: remove sway from greetd environments

- feat: nix syntax cleanup

- feat: cleanup programs module

- feat: make ToggleTerm terminal horizontal

- feat: only @wheel should be allowed in store

- feat: remove useless override definitions

- feat: update flake

- feat: update flake

- feat: update packages

- feat: unlock keyring on greetd login

- docs: update docs

- feat: update intel gpu options

- dev: give up on nvidia

- feat: cleanup

- style: nix syntax

- feat(themes): new color palette

- feat: cleanup

- feat: cleanup

- feat: enable network optimizations only on demand

- feat: clean up nvidia module

- dev: more work on getting nvidia to work

- feat: cleanup

- feat: prism should use catppuccin mocha

- feat: update flake

- docs: update todo

- dev: monochrome palette?

- feat: make schizofox optionally sane

- dev: disable nvidia for the two billionth time

- feat: clean up nvidia module

- feat: import the login module

- feat: unload i915 kernel modules if its a hybrid nvidia system

- dev: attempt to make zathure pick up pdfs

- feat: update tofi launch command

- feat: update tofi config

- feat: update flake

- feat: capitalise Hyprland in condition checks

- feat: update dotnet and jre deps for packages

- feat: update cnvim plugins

- feat: update flake

- feat: disable nvimtree on_startup opts

- feat: separate wayland and xorg login configs

- feat: update todo

- feat: update flake

- feat: update varda theme

- feat: update flake

- feat: relocate dotnet packages

- style: formatting

- feat: update README with new host

- feat: use the correct wine package on xorg

- feat: new host - Enyo

- feat: update flake

- feat: remove unused user

- feat: disable server module for icarus

- feat: use system-wide git signingKeys

- feat: update flake

- feat: update flake

- feat: matrix service

- feat: update fonts

- feat: pandoc

- feat: easyeffects

- feat: easyeffects

- feat: fractal matrix client

- feat: nmap in CLI packages

- feat: enable swallowing for thunar

- feat: make schizofox more schizo

- feat: update ikarus hosts

- feat: update icarus host

- dev: conform to openssh module changes

- feat: enable icarus host

- feat: include the new system-module options for icarus

- docs: update readme

- feat: angel-light color theme

- feat: disable schizofox pdfjs

- feat(gitea): switch from gitea to forgejo

- docs(TODO): update completed todo items

- refactor: bundle graphical programs based on type

- dev: turn off libreoffice override - package is fixed

- feat: update flake

- feat: bundle editors together to declutter terminal hm module

- feat: waybar reload/restart keybinds

- feat: update flake

- feat: update flake

- feat: gitflow and forgit

- feat: improve exa aliases

- feat: update flake

- feat: ani-cli overlay since the package takes too long to update

- feat: update flake

- chore: color themes cleanup

- dev: disable emacs, we all know vim is superior

- feat: use more color variables

- chore: post-refactor cleanup

- feat: console early startup

- feat: more bluetooth options to the bluetooth module

- feat: separate network related kernel modules and parameters

- chore: clean up intel kernel parameters

- feat: update flake

- feat: relocate networking related kernel parameters

- feat: update flake

- feat: modularize home-manager gaming configuration

- feat: specify direnv cache location

- feat: refactor graphical programs to separate apps and others

- chore: cleanup

- dev: update copilot nightly sha256

- feat: refactor to separate media services/programs

- feat: update flake

- feat: use transient services for foo terminal

- feat: modularize server config

- feat: bump fastfetch package ver

- feat: update flake

- chore: cleanup and comments

- feat: toggles for gaming module(s)

- feat: modularize system module skeleton

- feat: update TODO

- feat: update flake

- feat: update flake

- chore: cleanup

- feat: update flake

- feat: disable spotifyd and ragenix for now

- feat: update flake

- feat: package additions

- feat: opensnitch

- feat: nvidia DRM modules

- feat: more home-manager options

- chore(gaming): cleanup

- feat: obs plugins

- feat: bring back wezterm for benchmarking

- chore: cleanup

- feat: update flake

- feat: cleanup

- feat: move bluetooth to hardware modules

- dev: groundwork for self-hosted nitter service

- feat: modularize virtualization further

- feat: update todo

- feat: periodical notes on my system configurations

- modules/system/default.nix

docs: elaborate on "broken" drivers

- feat: ragenix gets its own file

- feat: ragenix gets its own file

- feat: separate tpm option from prometheus host config

- feat: update flake

- feat: update flake

- feat: update flake

- feat: repurpose spicetify dir for spotifyd

- feat: clean up hyprland config

- feat: seperate media services

- feat: bring back kitty term

- style: expand the preview image

- feat: update flake

- feat: TCP optimization

- feat: update ssh options with the new changes

- feat: update flake

- feat: groundwork on program overrides + new options

- dev: first take of varda-theme base16 palette

- feat: merge separate sets into one

- dev: temporarily disable external hosts, again

- dev: disable footserver

- feat: swayidle gets its own service

- feat: sponsorblock?

- dev: remove scaling envvar from steam

- feat: use a nix file for hyprland config to use color variables

- dev: remove unused i686 emulation

- feat: tokyo-night palette

- feat: update flake

- dev: temporarily enable secondary hosts

- style: resize preview image

- feat: update flake

- feat: refactor system module to unite media and add bluetooth

- feat: refactor desktop module for conditional toggles

- feat: update hosts with new opts

- feat: docs: update todo and usage instructions

- feat: require specific device types for terminal apps and programs

- feat: update flake

- feat: require specific device types for graphical apps

- feat: music taggin utilities

- dev: relocate hyprland hm-module input

- feat: update flake

- feat: gamemode cleanup

- feat: update flake

- dev: temporarly disable packages that cause build failures

- feat: update flake

- feat: deprecate NUR until a togglable NUR module

- Merge pull request #4 from viperML/system-module

dev: fix nix-doom-emacs url
- dev: I can't make this up

- feat: README cleanup

- feat: update fastfetch version

- feat: update flake

- feat: thunar thumbnails

- feat: refactor grafana and prometheus

- feat: update flake

- feat: new donation link

- feat: guess you can sponsor me now?

- feat: wakatime home envvar to clean up wakatime configs

- feat: DRM fix option for schizofox

- feat: separate virtualization module

- feat: modular package config

- feat: update flake

- feat: waybar module toggle

- feat: hyprland module toggle

- feat: update flake

- feat: update flake

- feat: vulkan pkgs

- feat: extend system module to home-manager

- feat: update flake

- feat: remove neovim from devshell

- dev(schizofox): seperate security and qol features

- feat: cleanup

- I give up

- feat: update schizofox

- dev: note down current TODOs for future reference

- feat: implement display protocol setting

- dev: first working version?

- dev: todo

- feat: conditional envvars for nvidia and wayland

- dev: cleanup

- dev: wrong place, probably not the wrong time

- dev: attempting to build a working system

- style: wording

- feat: update flake

- docs: initialize user "guide"

- dev: uncomment - no effect

- feat: attempt to fix anonymous function at...

- feat: refactor according to best nix practices

- feat: system module

- feat: conditional bootloader imports

- feat: new options & cleanup

- feat: update flake

- feat: init xorg module

- dev: remove unused import in cloneit deriv

- feat: import wayland, enable conditionally

- feat: relocate fonts to desktop module from wayland

- feat: cleanup

- feat: follow the new module format in hosts

- feat: replace hardware modules with system modules

- feat: relocate overlays to pkgs/

- feat: intel xorg driver

- feat: enable wireplumber

- feat: more vscode extensions for webdev

- feat: append lists on lists to extend PATH and steam compat tool path

- feat: more chess utilities

- feat: break overlays into multiple files

- feat: update flake

- feat: update flake

- feat: break terminal tools into multiple files

- feat: xdg bin path

- feat: update flake

- feat: btrfs settings for icarus

- feat: compatibility issues for base iso

- feat: update flake

- feat: thunar plugins

- feat: seperate gitea and nginx hosts

- feat: new host for installation media

- feat(btrfs): compress root subvol as well

- feat: cleanup

- feat(nvidia): modesetting module

- feat: update waybar style

- dev: debloat

- feat: update flake

- feat(helix): nix language root

- feat(newsboat): cleanup

- feat: chess!

- feat(nix): cleanup

- feat: wireless regulatory database

- feat: reverse engineering utils

- feat: games from default nixpkgs

- feat: emacs font

- dev: update README with more warnings

- feat: upscaling via anime4k

- feat: mpv hm config

- feat: chess apps + stockfish

- dev: try to unlock the keyring on login

- feat: move btrfs autoscrub to btrfs module

- feat: import ranger module

- feat: reload system units on rebuild

- feat: update helix config

- feat: ranger

- dev: reset steam compat tools path

- feat: steam compatibility tools override

- feat: proton-ge

- feat: show zombie parents script

- feat: clean up system packages

- feat: clean up system packages

- feat: update flake

- feat: update flake

- feat: cleanup

- feat: jellyfin module for servers

- dev: relocate cross platform emulation module

- feat: update flake

- dev: relocate cross platform emulation to desktop

- feat: update flake

- feat: do not inhibit while terminal is focused

- feat: import vscode module

- dev: relocate WLR_NO_HW_CURSORS envvar

- feat: image recipe for icarus

- feat: update flake

- feat: systemd.enable

- feat: update flake

- feat: cleanup

- feat: btrfs module

- feat: update flake

- feat: btrfs module

- feat: update flake

- feat: chromium overlay

- feat: update flake

- feat: vim keys in tab complete menu

- feat: document kernel modules

- feat: modularize users

- style: wording

- Merge pull request #3 from SoraTenshi/patch-1

Upgrade Experimental Helix branch to most recent
- Upgrade Experimental Helix branch to most recent
- feat: update flake

- feat: ISO recipe for prometheus

- style: cleanup

- feat: make intel go FAST

- feat: mainline xanmod kernel

- feat: update readme

- feat: update flake

- feat: easyeffects

- feat: improve power saving via tlp and udev rules

- feat: switch back to mainline kernel

- feat: update flake

- feat: use xanmod on prometheus

- feat: update README

- dev: disable gamescope due wlroots mismatch

- feat: remove tlauncher, laptop not stronk

- feat: tlauncher derivation

- feat: x11 compatibility

- feat: nix-gaming pkgs

- feat: update flake

- feat: cleanup for laptop module

- feat: clean up gaming module

- feat: separate bootloader and plymouth settings

- feat: insert cross compilation module

- feat: update helix settings

- feat: cleanup hosts

- feat: separate hm from nixos modules

- feat: disable nix-index zsh integration

- feat: git graph

- feat: nix-index service

- feat: enable tor client

- feat: insert laptop module

- feat: update flake

- feat: remove nixos-generators

- feat: laptop module

- feat: separate tor client settings

- feat: relocate touchpad to laptop module

- feat: modularize binfmt

- feat: mkDefault intAuth false

- feat: separate binfmt

- feat: disable fzf tab

- feat: nvidia driver cleanup

- feat: waybar cleanup

- dev: groundwork for future hardware modules

- feat: update flake

- feat: update readme

- feat: update xdg data dirs for flatpak

- feat: update flake

- feat: go back to catppuccin-mocha

- feat: switch to decay as primary theme

- feat: remove nixos-generator skeletons

- feat: cleanup bin

- feat: network hostID

- feat: purge unnecessary image config

- feat: cleanup

- feat: decay palette

- feat: groundwork for decay base16

- TODO: make a decay color palette because theirs SUCK

- feat: change dunst size

- feat: change dunst width

- feat: update dunst

- feat: use cleanup

- feat: change zsh completions

- feat: update dunst icons

- feat: update flake

- feat: more zsh matches

- feat: pkgs for img preview script

- style: formatting

- feat: convenience shell scripts

- feat: divide up gtk/qt configs

- feat: imv package

- dev: bring back license

- feat: relocate README to github dir

- feat: organize git aliases

- dev: rename neovim again, again

- dev: move back gammastep service

- feat: rename neovim again, again

- dev: remove maintainers from pkgs

- feat: cleanup

- style: formatting

- feat: relocate gammastep service

- feat: up rofi font size

- feat: rename wallpapers

- feat: cliphist service

- feat: update flake

- feat: update readme

- help

- feat: relocate GTK module to themes directory

- feat: disable nm-applet

- feat: move "service" modules to their own directory

- dev: disable no_gaps_when_only

- feat: groundwork for more hardware modules

- feat: alter cachix priority

- dev: avoid using open source drivers on a GTX 1050

- feat: make open-source nvidia drivers default

- feat: relocate GTK module to themes directory

- feat: relocate GTK module to themes directory

- feat: cleanup

- Implement nix-colors for declarative theming.

We merge it half-done because we rawdog this shit.
- Merge branch 'nixos' into nix-colors
- feat: seperate webcord as a module

- feat: update flake

- feat(nix-colors): theme waybar because forgor

- feat(nix-colors): switch dunst colors around

- feat(nix-colors): switch to nix-colors for fzf

- feat(nix-colors): switch to nix-colors for kitty

- feat(nix-colors): switch to nix-colors for foot

- feat(nix-colors): switch to nix-colors for swaylock

- feat(nix-colors): switch to nix-colors for rofi

- feat: update hyprland border colors

- feat(nix-colors): switch to nix-colors for dunst

- dev: relocate themes module

- feat: update flake

- dev: relocate themes module

- feat: relocate theme configurations

- feat: use nix-colors for declarative theming

- style: formatting

- feat: update flake

- feat: update nix config

- feat: update flake

- feat: flake cleanup

- dev: update emacs hash

- dev: disable wezterm because it sucks

- feat: content addressed nix

- feat: update flake

- feat: update flake

- dev: disable resolved to fix networking?

- feat: flake level nix fonfig

- feat: update flake

- feat: blur kitty

- feat: update flake

- feat: update system state version

- dev: remove gnome packages from syspkgs

- feat: move gnome packages to HM

- feat: better nix practices

- feat: cleanup

- feat: update flakee

- feat: disable tor client

- feat: update flake

- dev: comment out networking nameservers

- feat: drop wlroots patches

- feat: update flake

- feat: update emacs hash

- feat: nixos-generators

- feat: new font

- dev: disable nvidia again

- dev: attempt to fix pi bootloader conflicts

- feat: update flake

- feat: remove spotifyd

- dev: placeholder AMD Module

- feat: update flake

- feat: update flake

- feat: update readme to better represent current refactor

- dev: disable spotifyd service for now

- refactor: reorganize common modules and services

- feat: refactor wayland

- feat: modularize hardware configs

- feat: cleanup nvidia settings

- feat: udisk udev

- feat: disable nvidia again, again

- feat: update flake

- feat: major refactor for organization

- feat: work on repo README

- feat: disable cargo for now

- feat: term typer

- feat: disable gaps while there is a single window active

- feat: update shell & vim color palette

- feat: update flake

- feat: update flake

- feat: better grim ss

- style: refactor wezterm conf

- feat: btm

- dev: disable plymouth themeing again

- feat: update flake

- feat: make gnupg xdg compliant

- feat: shell config cleanup

- feat: testing w/ wezterm

- feat: git operation settings

- feat: update flake

- dev: disable nvidia module again, it broke

- feat: obsidian

- feat: xdg compliant zsh paths

- feat: new wallpaper

- feat: catppuccin mocha

- chore: groundwork

- feat: clean up overlays

- feat: FINALLY fix plymouth overlay holy hell

- feat: update flake + emacs rehashed

- dev: shelf the plymouth themes for now :(

- feat: mpd notifs w/ dunst

- dev: plymouth theming?

- feat: groundwork on streamlining overlays

- feat: grub for servers

- feat: gc more often

- dev: ignore direnv dir

- feat: wrong dir

- feat: bring back direnv

- doc: describe hosts

- feat: modularize user configs

- dev: more groundwork for overlays

- dev: plymouth themes overlay

- feat: update flake

- feat: xdph screensharing

- feat: disable tor service

- feat: disable nvidia module as dGPU is not detected

- style: refactor

- dev: too lazy to look into self attribute missing

- feat: groundwork for overlays

- feat: vscode hm module

- feat: discord hm module

- feat: clean up packages

- feat: qemu for virtualization

- feat: intel microcode

- feat: modularize shell config

- dev: testing with OBS for game capture

- feat: bring xdg-ninja to nixos desktop

- feat: intel media drivers

- feat: update flake

- feat: update flake

- feat: ssh agent

- dev: mess with wayland native wine

- dev: groundwork for server services

- feat: helix

- feat: nvim lsp update

- feat: global doas

- feat: update flake

- feat: time date format for swaylock

- feat: bitwarden addon for vaultwarden instance

- feat: nvim-ts-rainbow

- feat: update prometheus pubkey

- dev: do not pin waybar rev

- feat: upgrade home.stateVersion after gtk fix

- feat: more groups for doas

- feat: modularize server services

- feat: update firefox startpage

- feat: update flake

- feat: update blocker list

- feat: foot and waybar changes

- feat: allow unsupported systems

- feat: foot & shell cleanup

- feat: cleanup and modularize

- feat: FZF options

- feat: nix config & starship

- feat: lutris & bluetooth

- feat: configure TPM module

- style: nitpick

- feat: update flake

- feat: full refactor for fixes and efficiency

- dev: get rid of README for future rework

- feat: re-add current generation command

- dev: remove firefox nightly

- dev: update firefox

- feat: update flake

- dev: another refactor, please work this time

- dev: bootloader changes for atlas and prometheus

- dev: bootloader changes for atlas and prometheus

- feat: bring back direnv

- dev: disable proton-ge module for now

- feat: post-refactor cleanup

- dev: refactor

- dev: checkpoint?

- dev: bring back logind init

- dev: exhaust options for home-manager timeout

- dev: foolish attempts to make home-manager work PLEASE

- style: formatting

- feat: maybe fix discord?

- feat: cleanup

- feat: remove xserver settings

- feat: don't use zram on all hardware

- dev: relocate some more core modules

- feat: re-locate some "core" modules

- feat: more nvidia/wayland envvars

- dev: revoke ssl certs

- dev: start disabling services for the refactor

- feat: refactor bootloaders

- dev: update atlas hw cofig

- dev: undefine server bootloader

- feat: re-enable gitea

- update prometheus pubkey

- feat: terminal font changes

- dev: get rid of github stuff, workflows cringe

- feat: improve rofi search

- dev: p sure it patches the neofetch file

- dev: rename and try again

- dev: try with git diff

- dev: please

- dev: I don't know how to use patch

- dev: patch me baby one more time

- feat: export nicksfetch again

- dev: patch the patched patch for nicksfetch patch

- dev: kill me

- feat: doom emacs

- dev: fuck rust

- dev: please work

- dev: cleanup for nicksfetch

- feat: patch the patch for the nicksos patch

- dev: rust nightly

- funny

- style: formatting

- feat: rename wallpaper package for clarity

- Revert "feat: rename wallpaper package for clarity"

This reverts commit 2ebcd8510d780da1cf4f4292e1ab5adf1ef71901.

- feat: rename wallpaper package for clarity

- dev: skeleton for wallpapers package

- feat: get rid of git LFS

- dev: neovim plugins maybe?

- dev: proton-ge?

- style: formatting

- feat: reorganize hw-config for btrfs subvols

- feat(gitea): update repo licenses

- feat: patch security hole

- feat: /tmp on tmpfs

- featç: update waybar weathet widget

- feat: pin nixpkgs version to make nix search faster

- feat: enable and configure xserver, again

- feat: cleanup

- refactor: seperate host configs for atlas

- feat: ragenix

- feat: update flake

- feat: rename hostname in nix test function

- refactor: network wait timer style change

- feat: autosign commits

- dev: overlay overhaul

- dev: configure wlr portal

- dev: refactor server structure

- feat: replace discord-canary with discord

- dev: refactor server & configure openssl

- Merge branch 'nixos' of github.com:/notashelf/dotfiles into nixos

- dev: update nix settings

- dev: prepare atlas host

- refactor: remove duplicate services

- refactor: steam needs to be rewritten

- dev: nvidia module again

- dev: rename openasar overlay

- forgot what this was

- style: I want it that way

- dev: disable proton-ge for now

- dev: fall back to 'default' hardware for atlas

- style: formatting

- dev: update proton version

- style: update readme

- refactor: move overlay source for desktop

- dev: update flake

- style: formatting

- dev: overlay rework pt. 2

- dev: update hardware config

- Merge branch 'nixos' of github.com:/notashelf/dotfiles into nixos

- dev: change check branch
- dev: overlay rework?

- style: formatting

- refactor: refactor?

- dev: override instead of calllPackage

- dev: plymouth but with an overlay?

- dev: export plymouth-packages

- dev: plymouth rework in progress

- feat: make emacs work???

- dev: emacs no worky

- dev: try out emacs overlay

- dev: kvantum changes

- style: formatting

- dev: formatting

- dev: dip my feet in overlays

- dev: fuck with overlays

- dev: fuck with overlays

- feat: update startpage w/ more links

- dev: switch to LFS for images
	new file:   .gitattributes
	modified:   assets/colors.png
	modified:   home/graphical/gtk/default.nix
	modified:   home/graphical/hyprland/wall.png
	modified:   home/graphical/waybar/sakura.png

- dev: prepare for nix module

- dev: prepare for nix module

- dev: checkpoint

- style: formatting

- h

- refactor: holy fuck what have I done

- dev: yeet the nix module, it's been fun :(

- dev: import flake utils

- dev: import nix module

- Nixos

- style: formatting

- dev: not ready

- feat: hyprland cleanup

- feat: cleanup gpg & xdg

- refactor: simplify graphical applications

- feat: theme vendor logo

- dev: test grub conf

- dev: disable cloneit pkg

- dev: default bootloader to grub

- dev: default grub to true

- style: rename hosta after greek mythos

- refactor: move waybar scripts into scripts dir

- fuck

- fuck

- dev: we fucking tried?

- feat: rofi & waybar refactors

- dev: change XDG directories

- refactor: relocate services

- refactor: relocate services

- refactor: remove obsolete services

- Merge pull request #1 from fufexan/fixes

Fixes
- even more fixes

- update lock & formatting

- style: lint

- style: lint

- feat: simplify common config

- style: lint

- please work

- dev: modularize config

- dev: testing custom packaging

- refactor: un-contain nix files

- refactor: contain nixfiles

- feat: formatting via alejandra

- style: format configs

- Merge branch 'main' of github.com:NotAShelf/dotfiles

- refactor: refactor, lol

- dev: pls work

- refactor: move everything around as I please

- refactor: move everything around as I please

- dev: first attempt at self packaging

- build: discard graphene host

- style: syntax

- style: whitespaces

- refactor: move services

- discard grapene host

- switch dirHashes

- getting my feet wet

- update flake

- refactor: refactor, lol

- dev: pls work

- refactor: move everything around as I please

- refactor: move everything around as I please

- dev: first attempt at self packaging

- build: discard graphene host

- style: syntax

- style: whitespaces

- refactor: move services

- discard grapene host

- switch dirHashes

- getting my feet wet

- feat: update flake

- Merge pull request #66 from sioodmy/kvantum

feat: catppuccin kvantum theme
- feat: catppuccin kvantum theme

- Merge pull request #65 from sioodmy/waybar-padding

Waybar padding
- feat(waybar): swallow toggle

- feat(waybar): swallow toggle

- Merge pull request #64 from sioodmy/waybar-padding

fix(waybar): padding
- docs: update readme

Signed-off-by: sioodmy <81568712+sioodmy@users.noreply.github.com>
- docs: credit @fufexan

Signed-off-by: sioodmy <81568712+sioodmy@users.noreply.github.com>
- Merge pull request #63 from sioodmy/nulls

fix(vimuwu): alejandra formatting
- Merge pull request #62 from sioodmy/hostsblock

Block junk with hosts file
- feat: block junk

- Update README.md

Signed-off-by: sioodmy <81568712+sioodmy@users.noreply.github.com>
- Merge pull request #61 from sioodmy/rework

feat: github workflow for formatting
- feat(vimuwu): alejandra null-ls formatting

- feat: github workflow for formatting

- Merge pull request #60 from sioodmy/rework

Rework
- feat: cleanup and refactor overlays

- feat: moved hyprland patch away from flake.nix

- feat: modularize system configuration

- feat: refactor, schizofox config

- feat: conventional commit message workflow

- feat: alejandra github workflow

- update

- update

- update

- update

- cleanup

- update

- screenshare now worky

- .

- cleanup

- update catppuccin darkreader

- add catppuccin darkreader

- add catppuccin darkreader

- Update README.md

Signed-off-by: sioodmy <81568712+sioodmy@users.noreply.github.com>
- Merge pull request #59 from sioodmy/nvim-mini

update neovim config
- update neovim config

- update

- update

- update

- update

- update

- update

- update

- add autosave plugin

- update

- update

- update

- update

- update

- update

- Merge branch 'main' of github.com:sioodmy/dotfiles

- Update README.md

Signed-off-by: sioodmy <81568712+sioodmy@users.noreply.github.com>
- Update README.md

Signed-off-by: sioodmy <81568712+sioodmy@users.noreply.github.com>
- update

- update

- update

- stop wasting time bitch

- Merge branch 'main' of github.com:sioodmy/dotfiles

- Update README.md

Signed-off-by: sioodmy <81568712+sioodmy@users.noreply.github.com>
- update

- Update README.md

Signed-off-by: sioodmy <81568712+sioodmy@users.noreply.github.com>
- update default browser

- update firefox config

- add startpage

- arkenfox stuff

- remove neovim overlay

- update

- update

- update

- Update README.md

Signed-off-by: sioodmy <81568712+sioodmy@users.noreply.github.com>
- Update README.md

Signed-off-by: sioodmy <81568712+sioodmy@users.noreply.github.com>
- update

- encryption

- add nvim tree keybind

- update

- Update README.md

Signed-off-by: sioodmy <81568712+sioodmy@users.noreply.github.com>
- update

- update

- update

- update

- update

- update

- cleanup

- update

- finally update flake

- Update README.md

Signed-off-by: sioodmy <81568712+sioodmy@users.noreply.github.com>
- update and little cleanup

- update

- Merge pull request #58 from sioodmy/wayland

Wayland
- update

- update

- feat: catppuccinfy pdf reader

- update

- Merge pull request #57 from sioodmy/wayland

Wayland
- feat: even more catpuccin

- update

- update

- update

- update

- Merge pull request #56 from sioodmy/wayland

WAYLAND TIME
- update

- update

- update

- update

- update

- update

- update

- update

- update

- update

- update

- update

- update

- update flake

- update flake

- add firefox schizo config

- update flake

- update flake

- update flake

- update flake

- update flake

- rework

- update

- cleanup: remove xorg stuff

- feat: move to mocha catppuccin

- feat: wayland

- feat: update flake

- Merge pull request #55 from sioodmy/batpuccin

feat: catppuccin bat theme
- feat: catppuccin bat theme

- feat: update flake

- feat: update flake

- feat: update flake

- feat: disable wifi powersave

- feat: update flake

- feat: update flake

- feat: thinkpad acpi

- feat: update flake

- feat: update configuration

- feat: update configuration

- feat: update flake

- feat: update flake

- feat: update flake

- feat: update configuration

- feat: update configuration

- feat: enable st

- Merge pull request #54 from sioodmy/st

St
- feat: update flake

- feat: update flake

- feat: unbloat

- feat: unbloat

- feat: update flake

- feat: update flake

- feat: remove awesomewm rightclick menu

- cleanup: remove unused service

- feat: update flake

- feat: update kernel params

- feat: new kernel params

- feat: update flake

- feat: update flake

- Merge pull request #53 from sioodmy/feature/neovim-smooth

feat(nvim): optimize config
- feat(nvim): optimize config

- Merge pull request #52 from sioodmy/fix/picom

fix(picom): replace deprecated settings
- Merge pull request #51 from sioodmy/newwallpaper

New wallpaper
- feat(awesome): new wallpaper

made by _dystop

- cleanup: remove unused wallpaper

- feat: update flake

- feat(system): enable mitigations

it makes system more secure

- feat: new kernel params

- feat: new kernel params

- feat: update flake

- feat(flake): update

- Merge pull request #50 from sioodmy/awesome

Awesome
- Merge branch 'main' into awesome
- Update FUNDING.yml
- Update FUNDING.yml
- Create  FUNDING.yml
- feat: update flake

- feat: update flake

- Merge pull request #49 from sioodmy/awesome

feat: update flake
- Merge pull request #48 from sioodmy/awesome

feat: rounded corners for awesome
- Merge pull request #47 from sioodmy/awesome

Awesome
- Merge branch 'main' into awesome
- Update README.md
- Update README.md
- feat: switch back to vanilla kernel

- Update README.md
- feat(nvim): auto formatting

this commit adds auto formatting via null-ls, this includes nixfmt, rustfmt, gofmt, clang_format and prettier

- feat(awesome): update config

- feat(awesome): update config

- feat(thinkpad): enable upower daemon

- feat(hosts): enable awesomewm for thinkpad

- feat(kitty): decrease font size

15 -> 12

- feat: new awesomewm config

- refactor(hosts): remove useless part

- feat(git): new aliases

- feat(cursor): catpuccin cursor theme

- feat(overlays): remove useless overlays

- feat(configuration): update to 22.05

- feat(flake): update

- docs: credits

- feat(sudo): custom prompt

- feat: update awesomewm config

- feat: update flake

- feat: rounded corners for awesome

- feat: update kitty config

- feat: update picom config

- feat: update packages

- feat: update system config

- feat: update neovim config

- feat: update flake

- feat: update picom config

- feat: update hosts

- feat: switch back to vanilla kernel

- Update README.md
- feat: update picom

- feat: switch to awesomewm

- feat: disable bspwm on host

- feat: update picom config

- feat: update bspwm configuration

- feat: update flake lock

- cleanup: remove unused inputs

- cleanup: remove unused configuration

- feat: update picom

- Merge branch 'mpv-modern'

- Merge pull request #46 from sioodmy/mpv-modern

Mpv modern
- feat: enable kitty ligatures

- feat: make picture-in-picture windows floating and sticky

- feat: update fzf theme

- feat: update flake

- feat: update picom config

- docs: update fetch screenshot

- feat: better animations

- feat: updat eww

- Merge branch 'main' of github.com:sioodmy/dotfiles

- Update README.md
- feat: update wallpaper

- Update README.md
- Merge pull request #45 from sioodmy/catppuccin

Catppuccin
- feat: upgrade catppuccin cursors

- feat: switch to catppuccin

- feat: update gtk

- feat: update dircolors

- feat: update neovim configuration

- feat: update picom configuration

- feat: update kitty theme

- feat: update discocss

- feat: update rofi theme

- feat: new font

- feat: update hosts

- feat: enable nvim autoindent

- Merge pull request #44 from sioodmy/picom

Picom animations
- feat: switch to different picom fork

- Merge branch 'main' of github.com:sioodmy/dotfiles

- docs: update readme
- feat: enable thunar keybinds

- feat: update flake

- cleanup: remove useless imports

- refactor: remove useless line

- feat: update flake

- feat: update packages

- feat: update picom configuration

- feat: screenshot tool shortcut

- feat: remove screenshot thing

- feat: update bspwm configuration

- feat: update hosts

- feat: make keepassxc floating

- Merge branch 'newbar'

- feat: disable kitty close warning

- feat: update picom configuration

- feat: update bspwm configuration

- feat: update flake

- feat: update bar

- feat: update bspmw configuration

- feat: disable amd kvm

- Merge pull request #43 from sioodmy/mpv

Mpv
- feat: update mpv

- feat: remove mpv from packages

- feat: enable mpv on hosts

- feat: update flake

- Merge branch 'main' of github.com:sioodmy/nixdots

- Merge pull request #42 from sioodmy/neovim

Neovim
- feat: nix flake.nix formatting

- Merge pull request #41 from sioodmy/neovim

feat: add prettier support
- Merge pull request #40 from sioodmy/neovim

feat: add neorg support
- feat: enable nord theme on delta

- feat: switch to xanmod kernel

- feaw: update neovim

- feat: update flake

- feat: update fonts

- feat: disable lockscreen timeout

- feat: update neovim configuration

- feat: neovide alias

- feat: new packages

- feat: update neovim alias

- feat: update neovim

- feat: update eww

- feat: new plugins

- feat: update alpha dashboard

- feat: change kitty font

- feat: switch to jetbrains mono font

- feat: new packages

- feat: update flake

- feat: new packages

- docs: remove useless screenshots

- docs: remove gallery

- docs: update totally not stolen readme

- docs: update screenshot

- feat: new rofi config

- feat: update discocss

- feat: update neovim configuration

- Merge branch 'main' of github.com:sioodmy/nixdots

- feat: update neovim configuration

- feat: update discocss

- feat: new keymaps

- feat: update neovim configuration

- feat: update flake

- feat: update discord theme

- feat: update alias

- feat: switch to brave browser

- Merge pull request #39 from sioodmy/steven

Add adblock
- cleanup: remove useless files

- feat: update grub configuration

- Merge pull request #38 from sioodmy/volume

Volume and brightness indicators
- Merge pull request #37 from sioodmy/chromium

Ungoogled-chromium schizo confiuration
- feat: enable chromium on hosts

- feat: new orgmode config

- feat: update gtk config

- Merge branch 'main' of github.com:sioodmy/nixdots

- Merge pull request #36 from sioodmy/precommit

feat: add pre-commit hooks
- Merge pull request #35 from sioodmy/zsh

feat: update zsh configuration
- feat: update zsh configuration

- cleanup: remove not working cronjobs

- Merge pull request #34 from sioodmy/flutter

Flutter
- cleanup: xrandr

- feat: new zsh config

- cleanup: nvim

- cleanup(eww): remove volume garbage

- Merge pull request #33 from sioodmy/tablemode

Tablemode
- feat(nvim): new cmp sources

- feat: bigger borders

- Merge pull request #32 from sioodmy/vimpatch

feat(nvim): new plugins
- feat(nvim): new plugins

- Merge pull request #31 from sioodmy/newvim

neovim configuration rework
- feat(nvim): configuration rework

- cleanup: nvim

- cleanup: nvim

- cleanup: nvim

- cleanup: remove useless file

- feat: bigger borders

- feat: update nvim configuration

- feat: update flake

- feat: debloating

- feat: debloating

- feat: more schizo hardening

- feat: update rofi colors

- feat: systemd status logs

- cleanup: remove useless nvim input

- feat: update flake

- Merge pull request #29 from sioodmy/nord

Nord
- cleanup: update nord thmee

- feat: switch to nord theme

- feat: new packages

- Merge pull request #28 from sioodmy/zsh

feat: update zsh config
- feat: update zsh config

- Merge branch 'main' of github.com:sioodmy/nixdots

- Merge pull request #27 from sioodmy/new

New
- feat: dunst configuration

- feat: enable dunst

- feat: upgrade to nix unstable

- feat: remove borders

- revert: remove notifications from eww

- feat: update dunst configuration

- revert: remove notifications from eww

- revert: bios

- feat: disable touchpad tapping

- Merge pull request #26 from sioodmy/coreboot

feat: coreboot support
- feat: coreboot support

- feat: improve emmet vim

- feat: update dunst configuration

- cleanup: remove unused fonts

- feat: update hosts configruation

- feat: update packages

- feat: update flake.lock

- feat: update rebuild alias

- revert: remove broken plugin

- Merge pull request #25 from sioodmy/nvim

Nvim
- feat: new configuration

- feat: new configuration

- Merge branch 'main' into nvim

- Merge pull request #24 from sioodmy/helix

Helix
- feat: update helix configuration

- feat: change colors

- feat: enable helix

- feat: comment and git plugin update

- Merge pull request #23 from sioodmy/autologin

feat: enable autologin
- feat: enable autologin

- Merge pull request #22 from sioodmy/nologin

feat: enable autologin
- feat: enable autologin

- Merge pull request #21 from sioodmy/wifi

feat(eww): add wifi indicator
- Revert "fix: autologin"

This reverts commit 88533b17283e130f54e4a71e62d6eafad35bff46.

- Merge pull request #19 from sioodmy/globalstatus

feat(nvim): enable global statusline
- feat(nvim): enable global statusline

- Merge pull request #18 from sioodmy/nologin

feat: enable autologin if the encryption is enabled
- feat: enable autologin if the encryption is enabled

- Merge pull request #17 from sioodmy/fusuma

Fusuma
- feat: update nix flake

- Merge pull request #16 from sioodmy/networkmanager

feat: enable networkmanager
- feat: enable networkmanager

- feat: remove steam from home packages

- feat: utilize thinkpad's search button

- feat: move laptop stuff to laptop config

- feat: move laptop stuff to laptop config

- feat: enable eww laptop config for thinkpad

- Merge pull request #14 from sioodmy/eww/t440p

Split eww config into desktop and laptop
- feat: split eww configuration into desktop and laptop

- Merge pull request #13 from sioodmy/thinkpad

Thinkpad T440P host
- feat: update graphene config

- feat: remove nvidia drivers from shared config

- Merge pull request #12 from sioodmy/mksystem

Mksystem
- feat: move overlays into mkSystem

- Merge branch 'main' of github.com:sioodmy/nixdots

- Merge pull request #11 from sioodmy/nvim

feat: update nvim configuration
- feat: update nvim configuration

- feat: remove zathura gui thing

- feat: remove neofetch alias

- feat: update host config

- Merge pull request #9 from sioodmy/tiramisu

Eww notifications via tiramisu
- Merge pull request #8 from sioodmy/nvim

feat: new dashboard
- feat: new dashboard

- Merge pull request #7 from sioodmy/iosevka

Iosevka
- feat: increase font size

- feat: change default font to Iosevka

- Merge pull request #6 from sioodmy/qutebrowser

feat: new adblock filters
- feat: new adblock filters

- Merge pull request #5 from sioodmy/ewwss

feat: add ability to close screenshot tool
- feat: update zsh configuration

- Merge pull request #4 from sioodmy/bettersxhkd

feat: move keybindings to different modules
- feat: move keybindings to different modules

- Merge pull request #3 from sioodmy/discordfix

Fix discocss
- feat: new background colors

- feat(discocss): base16 theme

- feat(qutebrowser): new adblock hosts

- docs: new screenshot

- docs: new screenshot

- Merge pull request #2 from sioodmy/lockscreen

Lockscreen module
- feat: remove useless line

- feat: enable lockscreen module

- docs: update readme

- docs: update readme

- Update README.md
- Update README.md
- Update README.md
- Update README.md
- docs: update readme
- docs: update readme
- docs: new screenshot

- docs: new gif

- feat: update packages

- feat(lf): new icon

- refactor: little flake rework

- Merge pull request #1 from sioodmy/modules

Modules
- feat: convert to user modules

- feat: new modules

- feat: update user config

- feat(udiskie): convert to module

- feat(sxhkd): convert to module

- feat(redshift): convert to module

- feat(zathura): convert to module

- feat(urxvt): convert to module

- feat(rofi): convert to module

- feat(qutebrowser): convert to module

- feat(kitty): convert to module

- feat(flameshot): convert to module

- feat(firefox): convert to module

- feat(dunst): convert to module

- feat(discocss): convert to module

- feat(alacritty): convert to module

- feat(xresources): convert to module

- feat(picom): convert to module

- feat(gtk): convert to module

- feat(eww): convert to module

- feat(bspwm): convert to module

- feat(zsh): convert to module

- feat(xdg): convert to module

- feat(nvim): convert to module

- feat(music): convert to module

- feat(lf): convert to module

- feat(gpg): convert to module

- feat(git): convert to module

- feat(fzf): convert to module

- feat(cava): convert to module

- feat(btm): convert to module

- feat(bat): convert to module

- refactor: cleanup

- feat: eww screenshot tool

- feat(bspwm): new gaps size

- feat: new aliases

- feat: new lf icons

- feat(btm): new config

- feat(ncmpcpp): improve configuration

- feat(nvim): git plugin

- feat(cava): smooth gradient

- feat(zsh): new prompt

- feat: xkb layout

- feat: update eww configuration

- style: volume script

- style: micvolume script

- feat: mic mute icon

- feat: update lf configuration

- feat: devour swallowing

- feat: xdg mime

- feat: git delta

- feat: better mic volume control

- feat: better volume control

- revert: remove open script

- feat: opener script

- revert: remove bspswallow

- feat: lf configuration update

- cleanup: remove ueberzug dependency

- feat: lf kitty image previews

- feat: lf configuration

- feat: lf file previewer

- feat: lf file manager

- feat: better bar

- style: nvim config minor changes

- refactor: move system packages to home packages

- 🚀 Add starship prompt

- 🔔 Update dunst configuration

- ❄Update bspwm and picom configs

- 🥁 Updated ncmpcpp configuraction

- 💥 Fix tdrop conflicts

- 📚 Add new snippets

- 📚 Add nvim snippets

- 📔 Add new fonts

- 📔 Add basic pandoc support

- ❄ Reoriganise flake

- 📔 Fix GIF

- 📔 Update README

- 🥵 Update eww configuration

- 🎵 Improve music widget

- 😀 Improve eww bar

- 😀 Improve eww bar

- 🐈 Update kitty configuration

- 🎨 Update wallpaper

- 🎶 Add cava configuration

- 📉 Add CPU usage widget

- 🧹 Cleanup

- 🧹 Cleanup

- 🍉 Update alacritty configuration

- 🧹 Cleanup

- 🧝 Update picom configuration

- 🪟 Update bspwm configuration

- 🐈 Change terminal to kitty

- 📦 Update packages

- ❄ Update flake

- 🚧 Fix eww

- 🚧 Add eww bar

- ☔ Fix dropdown terminal

- 🦀 More rust alternatives

- 🐱 Change default terminal to kitty

- ❄ Update configuration

- 🐵 Remove font variable since its defined in fontconfig

- 🐵 Remove font variable since its defined in fontconfig

- 🍵 Less gaps

- 🧹 Cleanup

- 🎨 Add wallpaper

- ✉  Add discord theme

- ☀  Add blue light filter

- 😀 Fix emojis

- ❄ Add nix zsh completions

- ❄ Reorganised flake

- 🧼 Remove not working discord theme

- 🐭 Disable mouse acceleration

- 🧹 Cleanup

- ♻ Config cleanup, better power optimization

- 📔 Update readme

- 📔 Update readme

- 📔 Update readme

- 📔 Update readme

- 📔 Update readme

- 📔 Update readme

- ❄ Update configuration

- 📖 Update README

- Update README.md
- 📷 New screenshots

- 📷 New screenshots

- 📷 New screenshots

- 🌠 Add dropdown terminal

- 🎹 New keybinds

- 🎹 New keybinds

- 🖼 Add bspwm window borders

- 🚀 Add grub theme

- ❄ Update configuration

- 🥶 Add emoji support

- Remove firefox urlbar thing

- Improve firefox privacy

- Moved packages

- Removed transparency

- Fix neovim config

- Add more soydev style completions to neovim

- Update configuration

- Update configuration

- Add alacritty configuration and catppuccin cursors

- Add kitty terminal configuration

- Update gtk font

- Merge branch 'main' into hosts

- Improve hosts

- Clean up config files

- Update

- Update zsh configuration

- Add qutebrowser configuration

- Improve hosts

- Revert "Change way of managing hosts"

This reverts commit fd44da6e4d5adea0a7153b0d6f7f0b7334ab0c61.

- Change way of managing hosts

- Remove not working config

- Update

- Update some configs

- Add gcc

- Add new screenshot

- Add preview screenshot

- Add udiskie and flameshot services configuration

- Add mpd and ncmpcpp configuration

- Add readme

- Add screenlocker

- Add desktop config

- Update system configuration

- Update picom configuration

- Update packages

- Update dunst configuration

- Add swallowing

- Fix nvim error on launch

- Fix rofi calculator issue

- Add catpuccin gtk theme

- Add bspwm swallowing

- Update rofi configuration

- Update flake description

- Update picom configuration

- Add foil hat type shit security

- Change gaps

- Resize polybar

- Remove poor man's nano shit

- Fix rofi-calc colors

- Remove dmenu from packages

- Switch from dmenu to rofi

- Add rofi config

- Add license

- Initial commit


### New

- apps/schizofox: fix renamed `drmFix` option

- editors/neovim: add custom spellfile

- treewide: add "vim" to luarc globals

- flake: add exiftools hook; rename lib.nix to utils.nix

- services/ags: fix excessive padding around battery widget

- flake/pre-commit: add npins sources to typos exludes

- terminal/tools: add git-peek

- networking/tailscale: add tagging options

- roles/iso: fix typo in import

- docs: add build with pandoc

- lib/xdg: fix typo in state_dir

- lib/xdg: add NB to the template

- system/security: add `noexec` to non-nix partitions

- hosts/enyo: add zstd compression for modules; enable cpu freq statistics

- docs: fix invalid date in preview

- services/ags: add percentage to battery tooltip

- system/containers: add missing stateVersion options

- options/media: add history.lua to list of default extensions

- docs: fix typos

- boot/generic: add recovery tools to initrd systemd path

- terminal/tools: add nix-init package & config

- hosts/epimetheus: add missing fs import

- teriminal/bin: add purge-direnv.sh

- services/adb: add android udev rules

- roles/workstation: fix missing option parents

- roles/workstation: add zswap configuration

- media/packages: add musikcube

- hosts: add missing system imports

- cpu/amd: add amdctl to vendored packages

- os/environment: add `dnsutils` to default packages

- roles/laptop: fix hyprctl usage in power monitor script

- hosts: add missing fs entries and options

- hosts/enyo: add  to /persist

- networking/tailscale: add operator option

- os/services: add doc comments to fstrim and fwupd

- security/kernel: add doc comments

- services/ags: add `nodejs-slim` to devShell

- wms/hyprland: add thunderbird specific windowrules; reorganize

- networking/tcpcrypt: fix invalid service section

- flake: add npins to flake outputs

- editors/neovim: add legendary.nvim

- os/environment: add doc comments

- services/ags: add additional tooling

and a shell.nix that uses linked channels

- services/ags: add hyprland package to ags runtime deps

- services/nginx: fix typos in static root

- services/nginx: add gpg key page

- system/os: add hyprland portal to xdg-portal configuration

- tools/zoxide: add `--cmd cd` to init args

- security/kernel: add additional kernel params; document existing kernel params

- lib/xdg: add DOCKER_CONFIG & _JAVA_OPTIONS

- shell/bin: fix invalid script names in ~/.local; add fs-diff.sh

- shell/zsh: add `--builders ""` to nix build alias

- shell/starship: add command timeout

- flake: fix typo in input doc

- modules/core: add element to workstation profile

- os/misc: add missing xdg-portal configuration import

- virtualization/qemu: add qemu and qemu_kvm packages to systemPackages

- wms/hyprland: add statusbar toggle keybind

- system/power: add low battery warnings to power_monitor

- docs: fix invalid link to the notes directory

- hosts: fix typos

assuming "A host" at line 38

- docs: fix typos

I assume you meant to write "or" in the Preface

- treewide: add missing imports after recent refactors

- flake: add generic hydra jobs

- programs/terminal: add initial neomutt configuration

- editors/neovim: add vim-nftables, restructure and simplify

- system/services: fix harmonia host bind

- core/roles: add a microvm role for minimal virtual machine setups

- flake/pkgs: add modprobed-db derivation

- options/services: add ports to common services

- ci: fix typo in action name

- services/forgejo-runner: add nix to runner packages

- editors/neovim: add lsp handler

- options/system: add kdeconnect and mangohud to enable options

- editors/neovim: add deferered-clipboard

- docs: add cheatsheet

	new file:   docs/cheatsheet.md
	renamed:    docs/TODO.md -> docs/todo.md

- networking/tcpcrypt: fix invalid module name in condition

- laptop/power: fix `dev.types` typo

- packages/gui: add helvum

- hardware/video: support 32bit only if system is 64bit

- services/ags: fix AppLauncher() not being a function

- flake: add hyprlamd-plugins input

- system/nix: add ags binary cache

- lib: add a systemd hardening helper

- os/environment: add rsync and man-pages to systemPackages

- packages/gui: add okular to shared packages

zathura cannot seem to have a working desktop item

- Revert "services/ags: add style.css to gitignores"

lib.filesets needs files added to git

- services/ags: add style.css to gitignores

- services/ags: add more packages to the wrapper

ags cannot access to the standard environment in our use case

- services/ags: add a bootstrappig script to package.json

- flake: add nodejs to the devshell

not ideal, but we need it to work with ags

- services/ags: add missing deps to the ags wrapper

- services/ags: add icons.js to source

- flake: add ags to inputs

- media/mpv: add more keybinds

- docs: add some comments

- os/environment: add IME configuration

- services/forgejo: add self-hosted runner instance

- types/server: add shellInit message

- editors/neovim: add foot wrapped neovim desktop entry

- lib: add `common.shellColors`

- environment/aliases: add a gpl3 alias to global aliases

- hosts: add leto

- core/nix: add garnix binary cache

it is required for prismlauncher

- apps/schizofox: add auto-tap-discard extension

- docs: add Solène's blog to helpful resources

- services/headscale: add missing enable condition

- editors/neovim: add transfer.nvim

- editors/neovim: add `mkdir.nvim`

- options: add renamedOptionaModule for renamed tailscale module

- services/nginx: fix redirect loop on the base domain

- lib: add `intListToStringList`

The name is absolutely horrendous, but the functionality is helpful.

- lib: add `intListToStringList`

The name is absolutely horrendous, but the functionality is helpful.

- services/redis: fix incorrect enable condition

- services/nextcloud: add extra apps

- shared/reposilite: fix option declarations

- core/options: add more options to the programs module

- os/environment: add `SUDO_EDITOR` variable

- flake/templates: add python template

- launchers/anyrun: fix applications config

- editors/neovim: add nvim-docs-view

- editors/neovim: add highlight-undo

- wayland/waybar: add oxocarbon preset

- secrets: add garage environment secret

- flake: add lock update script to devshell

- CI: fix cachix workflow

- CI: fix nix-install-action params

- types/server: add mastodon service

- services/searxng: add ko-fi

- flake: add disko to flake inputs

I hate everything, especially gerg

- hosts: fix gtk theme in style profiles

Catpuccin team cannot decide on a naming convention for shit

- templates/rust: add cargo to the shell

- flake: add flake schemas

- programs/git: add ccls cache to global ignorelist

- modules/system: add missing encryption module import

- parts/pkgs: fix incorrect path to present pkg

- flake: add schizofox to inputs

- flake: add missing self to template flakes

- flake: add Golang template

- options/theme: fix default kdeglobals.source

- server/services: add comments to each import

- editors/neovim: fix missing cursorWordline

- hosts/hermes: add theming configuration

- editors/neovim: add regexplainer to extra plugins

- style: add an indent lol

- media/sound: support 32Bit explicitly on x86 systems

- feat: additional emulation

- lib: fix invalid elemAt usage

- docs: add comments to more options

- modules/nixos: add wakapi module

- boot/plymouth: fix optional theme defaulting to none

- modules/virtualization: add waydroid to packages list if corresponding module is enabled

- launchers/tofi: add missing sys reference

- packages/gui: add sys.video.enable as a condition

- launchers/anyrun: fix invalid x and y coord values

- launchers/anyrun: fix invalid x and y coord values

- launchers/anyrun: add new module options from upstream flake

- pkgs: support aarch64-linux

- pkgs: support aarch64-linux

- modules/steam: add `withProtonGE` option

- treewide: add exported modules for export-only modules

- themes/gtk: fix theme name for catppuccin theme

- CI: fix yaml syntax in note viewer workflow

- tools/nix-shell: add perl to system packages

- docs: add new host

- programs/git: fix invalid signing email

Signed-off-by: NotAShelf <itsashelf@gmail.com>

- home/tools: fix invalid pinentry type

- services/waybar: fix PA mute icon size

- flake: add my own cache to the flake caches

- docs: fix dead links

- CI: fix typo in job name

- games/minecraft: add temurin 17 JRE to java packages

- core/network: additional nameservers

- core/network: additional nameservers

- services/mkm: fix secret name mismatch

- core/secrets: add nextcloud group and user to nextcloud secret ownership

- core/secrets: add gitea group to gitea secret ownership

- secrets: add cloud mailser secret

- services/gitea: fix missing parent attrset

- flake: support i686-linux

- waybar: fix funny volume icon

- modules/server: add override conditions for each service

- hosts: add virtualization module to helios

- dev: fix invalid mkm path

- server/services/mongodb: add missing pkgs to argset

- hardware/laptop/power: add cpupower-gui to packages

- hosts: add filesystem config to VMs

- system/nix: add helix binary cache

- hyprland: fix overlapping screenshot binds

- flake: support aarch64 systems

- server/services: add missing fqdn

- virtualization: add virt-viewer

- impermanence: additional directories

- home/packages: add graphical matrix client

- fix matrix???

- flake: fix incorrect agenix input URL

- core/system/nix: add enyo to builders

- system: add nix-builder secrets

- core/security: add more comments

- home/qt: fix kvantum theming

- flake: add anyrun to inputs

- home: add anyrun to available launchers

- hosts/helios: fix deprecated grub opt

- flake: support additional systems

- nvidia: fix offloadcmd opt

- home: fix mpd music dir

- pkgs: add fixed mov-cli to personal overlay

- system: add additional programs module options

- graphical: add sway as an optional session

- filesystems: support for additional filesystems

- fix: FINALLY fix nvidia hybrid graphics

- fix: use lib in scope

- fix: whoops

- flake: add hyprpaper to inputs

- home: add dolphin file manager to packages

- fix: update missing enable option

- dev(epimetheus): support ext4

- feat: add slides to desktop pkgs

- fix(wireguard): iptables rules

- fix: oh

- fix(server/wireguard): fix invalid wireguard ip

- fix: helios secrets

- fix: update ragenix for helios

- fix: quassel port needs to be signed int

- fix: wireguard secret name

- fix(helios): force noefi

- fix: no EFI support on helios

- fix(helios): make grub work?

- fix(boot/loader): server loader should be overridable

- feat: additional persistent directories

- fix: swaylock not picking up swaylock-effects package

- feat(shell): add script to find tmod files in steam workshop dir

- feat(hosts): add bootloader to shared modules

- feat: add tailscale

- feat: add nemo file manager

- feat: add shadower to system packages

- feat(desktop): add ms core fonts

- feat(waybar): add condtional cpu usage indicators

- fix: qemu virtualization

- feat(janus): add a simplified host for in-vm testing

- docs: add comments to hardware module imports

- feat: add cad software

- fix: zsh needs to be enabled per-system as well

- feat: add zstd compression to mounted disks

- dev: add nix-index to home packages

- docs: fix package name

- fix(waybar): bluetooth style

- fix: dunst

- fix: home-manager exports XCURSOR_SIZE as int

- feat: add zoom to system packages (yuck)

- feat: add key device for unattended boot

- docs: add more comments to the login module

- docs: add comments to more security related options

- fix(schizofox): locale for deepl module

- feat: add compression and noatime to btrfs subvols

- docs: add notes on my encrypted disk laptop eetup

- feat: add gaea to buildable images

- feat: add lshw to system packages

- feat(libreoffice): additional hunspell libraries

- feat: fixWebcam opt that unblacklists the relevant kernel module

- fix: invalid path to host keys

- feat: additional security options via auditd

- feat: add a quickbind for firefox

- feat: add noisetorch to services

- feat: add copilot.lua

- fix: use lib.optionals instead of lib.optionalString

- fix: autologin being overriden by greetd

- feat: add gh copilot

- fix: hosts using the old format for Hyprland as session

- feat: fix empty package from faulty condition check

- feat: add i3wm to the system as a fallback

- feat: add session autologin option

- feat: add i3 to the system module

- fix: collision between dotnet 6 and dotnet 7

- feat: add dotnet to steam extra packages for dotnet games

- feat: add git signing key to prometheus

- feat: add module opt for system git signingKey

- feat: add module opt for system git signingKey

- fix: x11 forwarding opt

- fix: deprecated openssh option

- fix iwlwifi pkg

- feat: add more firmware options to ensure compatibility

- fix: programs dir missing for server module

- fix: arch branch link

- fix: invalid hyperlink
- fix(networking): deprecated ssh option

- feat: add tofi to the list of launchers

- feat: add powertop for power consumption statistics

- dev: add forgit zsh plugin

- docs: add comments to nvim plugins

- feat: add ani-cli to media packages

- dev: add more items to TODO

- feat: add chromium overlay to system pkgs

- docs: add indev warning to docs

- feat: add first program override to disable libreoffice temporarily

- feat: add STARSHIP_CACHE envvar

- feat: add gaps around waybar (:coolcry:)

- feat: add gamescope option to gaming module & add default programs

- feat: add server packages attrset

- fix: typo in bluez pkg

- docs: add warning to `slub_debug` parameter

- fix: intel_backlight not being registered

- fix: missing head and tail commands

- feat: fix dunst brigtness indicator

- fix: infinite recursion in misc services

- fix: account for changed hybrid gpu identifiers

- fix: missing config import

- dev: fix nix-doom-emacs url

- fix: whoops
- feat: add fastfetch to flake outputs

- docs: add comments to system module

- fix: refactored isWayland opt

- fix: refactored isWayland opt

- fix: invalid img path

- style: add desktop preview to readme

- fix: typescript-language-server conflict w/ webcord

- fix: vscode extensions not working when extension dir is set

- fix: invalid package name

- feat: add more vscode extensions

- feat: add notifications to gamemode scripts

- dev: add btrfs module to the repository tree

- feat: add librewolf to system packages

- feat: add proton-ge to steam compatibility tools

- feat: add proton-ge to personal overlay

- fix: reocurring definition

- feat: add fastfetch to personal overlay

- fix: missing call

- fix: incorrect path reference in comment

- fix(tlp): tlp on intel 2nd gen+ devices

- fix(flatpak): missing {} in the PATH

- fix(waybar): ethernet icon

- feat: add nix-gaming to flake imports

- feat: add cloneit to system packages

- feat: add laptop module

- feat: fix missing cargo.lock

- feat: add file pkg

- feat: add DIRENV_LOG_FORMAT

- feat: add run-as-service

- dev: add github workflows again

- feat: add license for initializing projects

- fix: cleanup

- doc: add comments to configurations

- feat: add 32bit packages for wine

- feat: add 32bit packages for wine

- fix: defined nixPath twice

- feat: add nix-colors

- docs: add comments to flake

- fix: wezterm font not works

- feat: add mov-cli to pkgs

- fix: remove gnome services due to failing dependency

- doc: add comments to more system services

- fix: conflicting bluetooth service

- fix: why no mocha palette

- doc: add comments to obscure boot options

- feat: add more options to spotifyd

- fix: unbork the font config

- feat: add user to plugdev group

- feat: add lspci to pkgs

- fix: xdg dirs work now

- feat: add self to flake channels

- feat: additional services and programs for desktop

- fix: move fs config to toplevel for ff

- fix: correct host hashsums

- feat: add webcord

- feat: add IRC client

- feat: add bitfimt to emulate aarch64

- fix: fix GTK being funky with home-manager

- dev: fix emacs commit mismatch

- fix: mpd wants absolute paths smh

- fix: add the missing default.nix for hosts/icarus

- dev: add desktop pubkey

- fix: bootloader defined twice

- feat: add server specific users

- feat: add swap device

- dev: add the patched patch for the patched nicksfetch patch

- fix: doom emacs & nicksfetch

- fix: overlay switcharoo

- fix: update doom-emacs sha256 param

- fix: why am I like this

- fix: change invalid module paths

- feat: add mpd and ncmpcpp

- fix: fix flake check errors & un-default btrfs scrub

- feat: add ssh pubkey to my user

- dev: add wireshark to kvantum apps list

- fix: codeblocks relocated

- fix: code blocks relocated

- fix: fix swaybg not starting if device is plugged off (???)

- fix: suppress flake check related issues

- feat: add proton-ge???

- dev: add doom-emacs flake

- fix: fix does not provide attribute ... errors in devshell

- fix: fuck.

- fix: whoops

- fix: discord overlay works, stupidity banished

- fix(services): actually fix this time

- fix: wrong parent

- feat: add background nextcloud sync

- fix: fix whoopsie

- fix: how the fuck did this happen

- feat: add libreoffice

- fix: I am stupid 2: the electric boogaloo

- fix: syntax go brr

- feat: add rust-battop

- fix: calc worky?

- feat: add plymouth

- fix: grub should work

- fix: MISSING SEMICOLON AAAAAAAAA

- fix: you don't know how imports work, fuck off

- fix: make logind great again

- fix: rename hm to home-manager (forgor)

- fix: remove redundant system in system conf

- fix: why am I stupid

- fix: libless behaviour

- fix: syntax be gone

- fix: not how you use that

- fix: remove obsolete file reference

- fix: whoops!

- fix: actually fix the merge conflict

- fix?

- fix: complete broken expression

- feat: addional flake inputs

- feat: add steam & nextcloud to HM config

- fix: fix refactor errors

- fix: syntax

- fix: so THIS is how it's done

- fix: add cloneit package to the flake

- dev: add future kernel module

- fix: complete broken expression

- feat: addional flake inputs

- feat: add steam & nextcloud to HM config

- fix: fix refactor errors

- fix: syntax

- fix: so THIS is how it's done

- fix: add cloneit package to the flake

- dev: add future kernel module

- docs: add @Ludovico patch

Signed-off-by: sioodmy <81568712+sioodmy@users.noreply.github.com>
- fix(waybar): padding

- feat(git): add new alias

- fix(vimuwu): alejandra formatting

- fix: formatting

- fix: formatting

- fix: formatting

- fix: catppuccin gtk

- fix: deprecated nix shell

- fix: screenshare now worky

- feat: add brave browser

- fix: waybar weather widget

- feat: add rofi background

- feat: add waybar

- fixes

- fixes

- fix: nvim zen

- fix: bugs

- fix: thinkpad treshholds

- feat(awesome): fix terminal

- feat: add st-snazzy

- fix: networking

- feat: add new package

- fix: invalid kernel param

- style: fix indentation

- feat: add lm_sensors package

- fix(picom): replace deprecated settings

- fix(nvim): c formatter

- docs: fix typo

- style(awesome): fix formatting

- fix(zsh): launch time fix

- feat(awesome): add pulseaudio package

pulseaudio package adds pactl binary

- fix(network): waiting for dhcp

- feat(awesome): add configuration

WIP

- fix(picom): laggy window operations

disabling vsync fixes laggy window operations like dragging and resizing for nvidia non-free drivers

- feat(git): add git aliases

new git aliases and commitizen package

- feat: add awesomewm

- feat: add f2k repo

- feat: add home configuration

- fix: switch back to ibahgwan's picom fork

- feat: add lorri service

- feat: add direnv package

- fix: mpv

- feat: add mordenx script

- fix: remove copilot

- fix: remove copilot

- fix: picom

- fix: eww button

- docs: add new screenshot

- fix: nvim terminal colors

- docs: add color bar

- feat: add catppuccin theme

- fix: neovim treesitter issues

- fix: eww battery

- feat: add float only workspace

- feat: add mpv custom configuration

- feat: add nix formatter

- feat: add prettier support

- feat: add neorg support

- feat: add keepass

- feat: add copilot support

- fix: discocss font

- feat: add neovide support

- fix: tree plugin

- feat: add lsp.lua

- feat: add adblock module

- feat: add brightness indicator

- feat: fix hosts

- feat: add volume and brightness things

- fix: graphene config

- feat: add ungoogled-chromium configuration

- feat: add pre-commit hooks

- feat: add flutter support

- feat(nvim): fix colorizer

- feat: add syncthing

- feat(nvim): fix cmp background

- feat(nvim): add lua configs

- feat: add libreoffice

- feat: add monero-gui package

- fix: shutdown button

- feat(eww): fix scripts

- feat(eww): fix scripts

- fix: deprecated option

- fix: typo

- feat: add helix code editor

- docs: fix typo
- feat(eww): add wifi indicator

- fix: autologin

- feat: add fusuma gestures

- feat: add propper steam config

- feat: fix nvim config load problem

- feat: add eww bar modules for battery and brightness

- feat: add t440p hardware configuration

- feat: add thinkpad host configuration

- feat: add mksystem

- docs: fix readme
- style(eww): fix indentation

- style(eww): fix indentation

- feat(eww): add notification widget

- feat: add ability to close screenshot tool

- feat(picom): add support for flashfocus

- feat(eww): fix fullscreen issue

- feat(lockscreen): add more config options

- feat: add lockscreen module

- feat: add lockscreen module

- fix: add btm to hm config

- feat: add fetch flake

- feat(zsh): add zoxide

- feat(zsh): add nix-index

- feat(sudo): add lecture

- feat(sxhkd): add toggle bar key combination

- feat(eww): fix membar color

- feat(bspwm): fix escape and caps swap in csgo

- chore: add envrc

- feat(nvim): add spanish symbols as snippets

- feat(nvim): add stabilize-nvim plugin

- fix: workspace indicator color

- feat: add direnv

- feat: add nnn

- fix: cava

- fix: discocss

- feat: add fibonacci split ratio

- feat: add zsh dir hashes

- fix: ignore spaces in zsh hist

- fix: ignore duplicates in zsh hist

- fix: pandoc code block font

- feat: add todo

- chore: add gitignore

- feat(nvim): add dashboard



This changelog has been generated automatically using the custom git-cliff hook for
[git-hooks.nix](https://github.com/cachix/git-hooks.nix)

