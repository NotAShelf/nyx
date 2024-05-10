# Design Considerations

## Imports

> Guidelines for importing files within the `hosts` directory

- Only importing downwards. This means **no**
  `imports = [ ../../foo/bar/some-module.nix ];` - this is a classic pattern in
  NixOS configurations, but only gets more out of hand in time.
- Only one level of imports. Which means `imports = [./foo.nix]` is fine, but
  `imports = [ ./foo/bar/baz.nix ]` **is not**.
- Do not import defined modules outside `hosts/default.nix`. Meaning
  `hosts/enyo/default.nix` **cannot** have `../../../modules/..` in its
  configurations.

## Module System

> Guidelines for using the local module system for enabling or disabling
> services and programs

- Hosts should properly define their type and equipment. This means adequately
  defined `device.type`, `device.cpu` and `device.gpu` at the very least
- A host should contain at least **2** files/directories: `modules/` and
  `default.nix` importing the rest of the files
  - `modules/` should follow my local module system:
    `config.modules.{device,system,usrEnv,theme}` where applicable
  - `default.nix` may not contain anything other than an `imports = [ ... ]`
    importing rest of the files
- Additional host-specific configurations may either go into `system.nix` (e.g.
  kernel configuration) or have their own file (i.e Wireguard or hardware mount
  configurations) with their own file (i.e `mounts.nix`)

## Per-host hardware

> Guidelines for using `hardware-configuration.nix`

Previously I have required `hardware-configuration.nix` to be available (under
the name `hardware.nix`) for each host. This is no longer a requirement as
almost all host-specific hardware configuration have been moved to hardware
mixins located in `modules/`.

This further reinforces the requirement for the local module system, meaning
hosts **must** specify things like CPU vendors or hardware specific kernel
modules under `modules.device` or `modules.system`.
