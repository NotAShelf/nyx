# TODO

- [???] Move video and sound modules to a united "media" directory
- [x] Move isWayland to usrenv module from system module 
- finish making each module toggleable
  - [x] bootloaders
  - [x] home-manager
  - [x] desktop
    - [x] services
    - [x] programs
    - [ ] gaming
  - server
- [x] make cross-compilation togglable
- dynamic kernel module loading based on filesystems
- document more settings
- move previous hosts to the new host config format
  - [x] prometheus
  - [] icarus
  - [] atlas
  - ~~gaea~~ No need, no modules are imported.
- find enabling conditions for tor and xserver
- override options for enabled services
  - [ ] ~~home-manager module~~ Probably not necessary, users should bring their
  own homes.
  - [ ] desktop module
  - [ ] server module
- per-user secrets management via ragenix
- try to declutter inputs and unnecessary services
- toggle unnecessary/unsafe services or programs off by default

