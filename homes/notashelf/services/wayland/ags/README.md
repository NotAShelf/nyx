# Ags Configuration

A complete-ish shell replacement with a strong dependency on Hyprland.
Currently features a drop-in replacement for my old Waybar configuration
paired with a few other features that I found interesting, such as a program
launcher and desktop right click capture.

## Developing Locally

This configuration is primarily tied to a systemd user service - the
dependencies will be made available to ags inside a wrapper, so you do not
need to add anything to your `home.packages`. If developing locally, those
dependencies will need to be available inside your devshell. Take a look at the
`dependencies` list in `default.nix` and enter a shell with the required packages
to be able to run `ags -c ./config.js`. Currently `sassc` and `python3` are
necessary to be able to start the bar. If you skip this step, ags will not actually
display the bar.

## Credits

I have taken inspiration or/and code snippets from the cool people below. If you like
this configuration, consider giving them a star on their respective repositories.

- [Exoess](https://github.com/exoess/.files) - initially based on their configuration
- [SoraTenshi](https://github.com/SoraTenshi/ags-env) - the connection widget and weather module inspiration
- [Fufexan](https://github.com/fufexan/dotfiles/tree/main/home/programs/ags) - cool dude overall, inspiration
  for a few widgets and his willingness to help with my skill issues

And of course [Aylur](https://github.com/Aylur) for his awesome work on AGS.
