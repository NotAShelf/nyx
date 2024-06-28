# When, why and how to extend nixpkgs standard library

Those are my notes on extending nixpkgs with your own functions and
abstractions. There may be other ways of doing it, but this is the one I find to
be most ergonomic.

## What is `nixpkgs.lib`

In the context of the Nix package manager and NixOS, `nixpkgs.lib` refers to a
module within the Nixpkgs repository. The `nixpkgs.lib` module provides a set of
utility functions and definitions that are commonly used across the Nixpkgs
repository. It contains various helper functions and abstractions that make it
easier to write Nix expressions and define packages. We often use those
functions to simplify our configurations and the nix package build processes.

## Why would you need to extend `nixpkgs.lib`

While the library functions provided by nixpkgs is quite extensive and usually
suits my needs, I sometimes feel the need to define my own function or wrap an
existing function to complete a task. Normally we can handle the process of a
function inside a simple `let in` and be well off, but there may be times you
need to re-use the existing function across your configuration file.

In such times, you might want to either write your own lib and inherit it at the
source of your `flake.nix` to then inherit them across your configuration.

Today's notes document the process of doing exactly that.

## Extending `nixpkgs.lib`

I find the easiest way of extending nixpkgs.lib to be using an overlay.

```nix
# lib/default.nix
{
  nixpkgs,
  lib,
  inputs,
  ...
}: nixpkgs.lib.extend (
    final: prev: {
        # your functions go here
    }
  )
```

The above structure takes the existing `lib` from `nixpkgs`, and appends your
own configurations to it. You may then import this library in your `flake.nix`
to pass it to other imports and definitions.

```nix
# flake.nix
flake = let
    # extended nixpkgs lib, contains my custom functions
    lib = import ./lib {inherit nixpkgs lib inputs;};
in {
    # entry-point for nixos configurations
    nixosConfigurations = import ./hosts {inherit nixpkgs self lib;};
};
```

In this example (see my `flake.nix` for the actual implementation) I import my
extended lib from `lib/default.nix`, where I defined the overlay. I then pass
the extended lib to my `nixosConfiguratiıns`, which is an entry-point for all of
my NixOS configurations. As such, I am able to re-use my own utility functions
across my system as I see fit.

The problem with this approach is that it may be confusing for other people
reviewing your configuration. With this approach, `lib.customFunction` looks
identical to any lib function, which may lead to people thinking the function
exists in nixpkgs itself while it is only provided by your configuration. The
solution for that is simple though, instead of extending `nixpkgs.lib`, you may
define your own lib that does not inherit from `nixpkgs.lib` and only contains
your functions. The process would be similar, and you would not need to define
an overlay.

```nix
# flake.nix
flake = let
    # extended nixpkgs lib, contains my custom functions
    lib' = import ./lib {inherit nixpkgs lib inputs;};
in {
    # entry-point for nixos configurations
    nixosConfigurations = import ./hosts {inherit nixpkgs self lib';};
};
```

where your `lib/default.nix` looks like

```nix
# lib/default.nix
{
  nixpkgs,
  lib,
  inputs,
  ...
}: {
    # your functions here
}
```

You can find a real life example of the alternative approach in my
[neovim-flake's lib](https://github.com/NotAShelf/neovim-flake/blob/main/lib/stdlib-extended.nix).
