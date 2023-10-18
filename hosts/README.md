# Hosts

This file is the main entry point for my Nixos Configurations. All of them, without exception. Each host feature a unique configuration or/and purpose.

## 🖥️ Host Specifications

| Name         | Description                                                                                   |
| :----------- | :-------------------------------------------------------------------------------------------- |
| `gaea`       | Custom iso build to precede all creation                                                      |
| `erebus`     | Air-gapped virtual machine/live-iso configuration for sensitive jobs                          |
| `enyo`       | Desktop computer boasting a full AMD system. Daily workstation                                |
| `hermes`     | HP Pavillion with Ryzen 7 7730U, and my main portable workstation Used on-the-go              |
| `helios`     | Hetzner VPS for self-hosting some of my infrastructure                                        |
| `prometheus` | My HP Pavillion with a a GTX 1050 and i7-7700hq [^1]                                          |
| `epimetheus` | The succeeding brother host to Prometheus on the same machine, featuring full disk encryption |
| `atlas`      | Proof of concept server host that is used by my Raspberry Pi 400                              |
| `icarus`     | My 2014 Lenovo Yoga Ideapad that acts as a portable server. Not actively used                 |
| `artemis`    | x86_64-linux VM Host for testing basic NixOS concepts                                         |
| `apollon`    | x86_64-linux VM Host for testing for testing networked services, generally used on servers    |

[1]: Deprecated

## Design Considerations

### Imports

> Guidelines for importing files within the `hosts` directory

- Only importing downwards. This means no `imports = [ ../../foo/bar/some-module.nix ];`
- Only one level of imports. This means `imports = [./foo.nix]` is fine, but `imports = [ ./foo/bar/baz.nix ]` is not

### Module System

> Guidelines for using the local module system for enabling or disabling services and programs

- Hosts should properly define their type and equipment. This means adaquately defined `device.type`, `device.cpu` and `device.gpu` at the very least
- A hosts should contain at least 3 files: `system.nix`, `hardware-configuration.nix` and a `default.nix` importing the rest.
  - `system.nix` should follow my local module system: `config.modules.{device,system,usrEnv,theme}`
  - `hardware-configuration.nix` should ONLY have the things exclusive to the host. Such as filesystem configurations
  - `default.nix` may not contain anything other than an `imports = [ ... ]` importing rest of the files
- Additional host-specific configurations may either go into `system.nix` (i.e kernel configuration) or have their own file (i.e Wireguard or hardware mount configurations)
