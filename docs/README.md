# TODO

This is a poor attempt at making the *ultimate* declarative NixOS desktop for myself.
The main goal is to remove as few lines of code possible and instead use conditional
toggles to decide whether an option should be enabled. While this does seem to increase
the eval duration, it saves me (or perhaps other people who find this config) the trouble
of taking notes on specific features and going through them when they need.

## How to use

Create a directory in /hosts/ with the hostname of your device. This will, most of the time,
the only file you will need to edit to enable or disable basic system features. No 
more commenting out lines.

Inside your host directory (i.e hosts/prometheus) create a `default.nix`, `system.nix` and 
copy your hardware configuration to `hardware-configuration.nix`. Populate `system.nix`
from the template file found in this directory (`system-template.nix`) and add the following
lines to `default.nix`:

```nix
_: {
    imports = [
        ./system.nix 
        ./hardware-configuration.nix
    ];
}
```

This will import your system configuration and the hardware scan results in your host 
derivation. You then will need to define your host in `hosts/default.nix` Use my 
prometheus host as an example. It will import common system modules and make them available
for your system configuration over at `hosts/<hostname>/system.nix`. 

You can then enable and disable features inside your system.nix as you see fit.


Once everything is done, test your config with `nix flake check` and switch to it 
if it looks safe. You may do `sudo nixos-rebuild dry-activate --flake .#<hostname>`
before switching if you are really paranoid.

## Managing your home via home-manager 

If home-manager is enabled in your `system.nix` and you have defined a username in that 
same file, you may use home-manager to declaratively define your dotfiles. 


## Useful commands

- **nix flake update**: Updates your flake inputs
- **nix flake check**: Shows if your current configuration is valid and if it 
would evaluate
- **nixos-rebuild switch** Used to switch between generations. As this configuration
has flakes enabled, we need to pass a flake as an argument. For example 
`sudo nixos-rebuild switch --flake .#prometheus` would build and switch to the prometheus
host's derivation.




