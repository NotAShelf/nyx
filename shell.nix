# Make `nix-shell` consistent with `nix develop` for when I don't want to use Direnv
(builtins.getFlake ("git+file://" + toString ./.)).devShells.${builtins.currentSystem}.default
