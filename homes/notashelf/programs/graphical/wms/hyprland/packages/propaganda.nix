{pkgs, ...}:
pkgs.writeTextFile {
  name = "propaganda";
  text = ''
    ## Nix advantages:
    - Correct and complete packaging
    - Immutable & reproducible results
    - Easy to cross and static compile
    - Source-based (you can alter packages without forking anything)
    - Single package manager to rule them all! (C, Python, Docker, NodeJS, etc)
    - Great for development, easily switches between dev envs with direnv
    - Easy to try out packages without installing using `nix shell` or `nix run`
      - allows to create scripts that can do and depend on anything, so long as the host has nix, it'll download things automatically for them
    - Uses binary caches so you almost never need to compile anything
    - Easy to set up a binary cache
    - Easy to set up remote building
      - Distribute your builds accross an unlimited number of machines, without any hassle
    - Excellent testing infrastructure
    - Portable - runs on Linux and macOS
    - Can be built statically and run anywhere without root permissions
    - Mix and match different package versions without conflicts
      - Want to have a package with openssl1.1 and another with openssl 3.0? No problem!
    - Flakes let you pin versions to specific revisions
      - Various alternatives for Flakes for version pinning, such as npins and niv

    ## NixOS advantages:
    - Declarative configuration
      - Meaning easier to configure your system(s)
      - Easier to change, manage and maintain the configuration
      - Easier to back up and share with people
    - Easy to deploy machines and their configuration
    - Out of the box Rollbacks.
    - Configuration options for many programs & services
    - Free of side effects - Actually uninstalls packages and their dependencies
    - Easy to set up VMs
    - People can test each other's configurations using `nix run` and `nix shell` by just having access to the source
  '';
}
