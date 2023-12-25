{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) optionals versionOlder;
  mitigationFlags =
    (
      optionals (versionOlder config.boot.kernelPackages.kernel.version "5.1.13")
      [
        # we don't need restricted indirect branch speculation
        "noibrs"
        # we don't need no indirect branch prediction barrier either, it sounds funny
        "noibpb"
        # allow programs to get data from some other program when they shouldn't be able to - maybe they need it!
        "nospectre_v1"
        "nospectre_v2"
        # why flush the L1 cache? what if we need it later. anyone being able to get it is a small consequence, I think
        "l1tf=off"
        # of course we want to use, not bypass, the stored data
        "nospec_store_bypass_disable"
        "no_stf_barrier" # We don't need no barriers between software, they could be friends
        "mds=off" # Zombieload attacks are fine
      ]
    )
    ++ [
      "mitigations=off" # Of course we don't want no mitigations
    ];

  sys = config.modules.system;
  cfg = sys.security;
in {
  config = {
    # failsafe for idiots, god knows there are plenty
    assertions =
      optionals cfg.mitigations.disable
      [
        {
          assertion = cfg.mitigations.acceptRisk;
          message = ''
            You have enabled `config.modules.system.security.mitigations`.

            To make sure you are not doing this out of sheer idiocy, you must explicitly
            accept the risk of running your kernel without Spectre or Meltdown mitigations.

            Set `config.modules.system.security.mitigations.acceptRisk` to `true` only if you know what your doing!

            If you don't know what you are doing, but still insist on disabling mitigations; perish on your own accord.
          '';
        }
      ];

    security = {
      protectKernelImage = true; # disables hibernation

      # Breaks virtd, wireguard and iptables by disallowing them from loading
      # modules during runtime. You may enable this module if you wish, but do
      # make sure that the necessary modules are loaded declaratively before
      # doing so. Failing to add those modules may result in an unbootable system!
      lockKernelModules = false;

      # Force-enable the Page Table Isolation (PTI) Linux kernel feature
      # helps mitigate Meltdown and prevent some KASLR bypasses.
      forcePageTableIsolation = true;

      # User namespaces are required for sandboxing. Better than nothing imo.
      allowUserNamespaces = true;

      # Disable unprivileged user namespaces, unless containers are enabled
      # required by podman to run containers in rootless mode.
      unprivilegedUsernsClone = config.virtualisation.containers.enable;

      # apparmor configuration
      apparmor = {
        enable = true;
        killUnconfinedConfinables = true;
        packages = [pkgs.apparmor-profiles];
      };
    };

    boot = {
      kernel = {
        sysctl = {
          # The Magic SysRq key is a key combo that allows users connected to the
          # system console of a Linux kernel to perform some low-level commands.
          # Disable it, since we don't need it, and is a potential security concern.
          "kernel.sysrq" = 0;

          # Restrict ptrace() usage to processes with a pre-defined relationship
          # (e.g., parent/child)
          # FIXME: this breaks game launchers, find a way to launch them with privileges (steam)
          # "kernel.yama.ptrace_scope" = 2;

          # Hide kptrs even for processes with CAP_SYSLOG
          "kernel.kptr_restrict" = 2;

          # Disable bpf() JIT (to eliminate spray attacks)
          "net.core.bpf_jit_enable" = false;

          # Disable ftrace debugging
          "kernel.ftrace_enabled" = false;

          # Avoid kernel memory address exposures via dmesg (this value can also be set by CONFIG_SECURITY_DMESG_RESTRICT).
          "kernel.dmesg_restrict" = 1;
        };
      };

      # https://www.kernel.org/doc/html/latest/admin-guide/kernel-parameters.html
      kernelParams =
        [
          # make stack-based attacks on the kernel harder
          "randomize_kstack_offset=on"

          # controls the behavior of vsyscalls. this has been defaulted to none back in 2016 - break really old binaries for security
          "vsyscall=none"

          # reduce most of the exposure of a heap attack to a single cache
          "slab_nomerge"

          # only allow signed modules
          "module.sig_enforce=1"

          # blocks access to all kernel memory, even preventing administrators from being able to inspect and probe the kernel
          "lockdown=confidentiality"

          # enable buddy allocator free poisoning
          "page_poison=1"

          # performance improvement for direct-mapped memory-side-cache utilization, reduces the predictability of page allocations
          "page_alloc.shuffle=1"

          # for debugging kernel-level slab issues
          "slub_debug=FZP"

          # disable sysrq keys. sysrq is seful for debugging, but also insecure
          "sysrq_always_enabled=0" # 0 | 1 # 0 means disabled

          # ignore access time (atime) updates on files, except when they coincide with updates to the ctime or mtime
          "rootflags=noatime"

          # linux security modules
          "lsm=landlock,lockdown,yama,integrity,apparmor,bpf,tomoyo,selinux"

          # prevent the kernel from blanking plymouth out of the fb
          "fbcon=nodefer"
        ]
        ++ optionals cfg.mitigations.disable mitigationFlags;

      blacklistedKernelModules = lib.concatLists [
        # Obscure network protocols
        [
          "dccp" # Datagram Congestion Control Protocol
          "sctp" # Stream Control Transmission Protocol
          "rds" # Reliable Datagram Sockets
          "tipc" # Transparent Inter-Process Communication
          "n-hdlc" # High-level Data Link Control
          "netrom" # NetRom
          "x25" # X.25
          "ax25" # Amatuer X.25
          "rose" # ROSE
          "decnet" # DECnet
          "econet" # Econet
          "af_802154" # IEEE 802.15.4
          "ipx" # Internetwork Packet Exchange
          "appletalk" # Appletalk
          "psnap" # SubnetworkAccess Protocol
          "p8022" # IEEE 802.3
          "p8023" # Novell raw IEEE 802.3
          "can" # Controller Area Network
          "atm" # ATM
        ]

        # Old or rare or insufficiently audited filesystems
        [
          "adfs" # Active Directory Federation Services
          "affs" # Amiga Fast File System
          "befs" # "Be File System"
          "bfs" # BFS, used by SCO UnixWare OS for the /stand slice
          "cifs" # Common Internet File System
          "cramfs" # compressed ROM/RAM file system
          "efs" # Extent File System
          "erofs" # Enhanced Read-Only File System
          "exofs" # EXtended Object File System
          "freevxfs" # Veritas filesystem driver
          "f2fs" # Flash-Friendly File System
          "vivid" # Virtual Video Test Driver (unnecessary)
          "gfs2" # Global File System 2
          "hpfs" # High Performance File System (used by OS/2)
          "hfs" # Hierarchical File System (Macintosh)
          "hfsplus" # " same as above, but with extended attributes
          "jffs2" # Journalling Flash File System (v2)
          "jfs" # Journaled File System - only useful for VMWare sessions
          "ksmbd" # SMB3 Kernel Server
          "minix" # minix fs - used by the minix OS
          "nfsv3" # " (v3)
          "nfsv4" # Network File System (v4)
          "nfs" # Network File System
          "nilfs2" # New Implementation of a Log-structured File System
          "omfs" # Optimized MPEG Filesystem
          "qnx4" #  extent-based file system used by the QNX4 and QNX6 OSes
          "qnx6" # "
          "squashfs" # compressed read-only file system (used by live CDs)
          "sysv" # implements all of Xenix FS, SystemV/386 FS and Coherent FS.
          "udf" # https://docs.kernel.org/5.15/filesystems/udf.html
        ]

        # Disable Thunderbolt and FireWire to prevent DMA attacks
        [
          "thunderbolt"
          "firewire-core"
        ]

        # you might possibly want your webcam to work
        # we whitelsit the module if the system wants
        # webcam to work
        (optionals (!sys.security.fixWebcam) [
          "uvcvideo" # this is why your webcam no worky
        ])

        # if bluetooth is enabled, whitelist the module
        # necessary for bluetooth dongles to work
        (optionals (!sys.bluetooth.enable) [
          "bluetooth" # let bluetooth work
          "btusb" # let bluetooth dongles work
        ])
      ];
    };
  };
}
