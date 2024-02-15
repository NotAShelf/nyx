{
  config,
  lib,
  ...
}: let
  inherit (lib) optionals versionOlder mkForce;
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

      allowSimultaneousMultithreading = true;
    };

    boot = {
      kernel = {
        sysctl = {
          # The Magic SysRq key is a key combo that allows users connected to the
          # system console of a Linux kernel to perform some low-level commands.
          # Disable it, since we don't need it, and is a potential security concern.
          "kernel.sysrq" = mkForce 0;

          # Restrict ptrace() usage to processes with a pre-defined relationship
          # (e.g., parent/child)
          # FIXME: this breaks game launchers, find a way to launch them with privileges (steam)
          # gamescope wrapped with the capabilities *might* solve the issue
          # spoiler: it didn't
          # "kernel.yama.ptrace_scope" = 2;

          # Hide kptrs even for processes with CAP_SYSLOG
          # also prevents printing kernel pointers
          "kernel.kptr_restrict" = 2;

          # Disable bpf() JIT (to eliminate spray attacks)
          "net.core.bpf_jit_enable" = false;

          # Disable ftrace debugging
          "kernel.ftrace_enabled" = false;

          # Avoid kernel memory address exposures via dmesg (this value can also be set by CONFIG_SECURITY_DMESG_RESTRICT).
          "kernel.dmesg_restrict" = 1;

          # Prevent creating files in potentially attacker-controlled environments such
          # as world-writable directories to make data spoofing attacks more difficult
          "fs.protected_fifos" = 2;

          # Prevent unintended writes to already-created files
          "fs.protected_regular" = 2;

          # Disable SUID binary dump
          "fs.suid_dumpable" = 0;

          # Disable late module loading
          # "kernel.modules_disabled" = 1;

          # Disallow profiling at all levels without CAP_SYS_ADMIN
          "kernel.perf_event_paranoid" = 3;

          # Require CAP_BPF to use bpf
          "kernel.unprvileged_bpf_disabled" = 1;

          # Prevent boot console kernel log information leaks
          "kernel.printk" = "3 3 3 3";

          # Restrict loading TTY line disciplines to the CAP_SYS_MODULE capability to
          # prevent unprivileged attackers from loading vulnerable line disciplines with
          # the TIOCSETD ioctl
          "dev.tty.ldisc_autoload" = "0";
        };
      };

      # https://www.kernel.org/doc/html/latest/admin-guide/kernel-parameters.html
      kernelParams =
        [
          # make stack-based attacks on the kernel harder
          "randomize_kstack_offset=on"

          # Disable vsyscalls as they are obsolete and have been replaced with vDSO.
          # vsyscalls are also at fixed addresses in memory, making them a potential
          # target for ROP attacks
          # this breaks really old binaries for security
          "vsyscall=none"

          # reduce most of the exposure of a heap attack to a single cache
          # Disable slab merging which significantly increases the difficulty of heap
          # exploitation by preventing overwriting objects from merged caches and by
          # making it harder to influence slab cache layout
          "slab_nomerge"

          # Disable debugfs which exposes a lot of sensitive information about the
          # kernel
          "debugfs=off"

          # Sometimes certain kernel exploits will cause what is known as an "oops".
          # This parameter will cause the kernel to panic on such oopses, thereby
          # preventing those exploits
          "oops=panic"

          # Only allow kernel modules that have been signed with a valid key to be
          # loaded, which increases security by making it much harder to load a
          # malicious kernel module
          "module.sig_enforce=1"

          # The kernel lockdown LSM can eliminate many methods that user space code
          # could abuse to escalate to kernel privileges and extract sensitive
          # information. This LSM is necessary to implement a clear security boundary
          # between user space and the kernel
          #  integrity: kernel features that allow userland to modify the running kernel
          #             are disabled
          #  confidentiality: kernel features that allow userland to extract confidential
          #             information from the kernel are also disabled
          "lockdown=confidentiality"

          # enable buddy allocator free poisoning
          #  on: memory will befilled with a specific byte pattern
          #      that is unlikely to occur in normal operation.
          #  off (default): page poisoning will be disabled
          "page_poison=on"

          # performance improvement for direct-mapped memory-side-cache utilization
          # reduces the predictability of page allocations
          "page_alloc.shuffle=1"

          # for debugging kernel-level slab issues
          "slub_debug=FZP"

          # ignore access time (atime) updates on files
          # except when they coincide with updates to the ctime or mtime
          "rootflags=noatime"

          # linux security modules
          "lsm=landlock,lockdown,yama,integrity,apparmor,bpf,tomoyo,selinux"

          # prevent the kernel from blanking plymouth out of the fb
          "fbcon=nodefer"

          # the format that will be used for integrity audit logs
          #  0 (default): basic integrity auditing messages
          #  1: additional integrity auditing messages
          "integrity_audit=1"
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
          "vivid" # Virtual Video Test Driver (unnecessary, and a historical cause of escalation issues)
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
          "qnx4" # extent-based file system used by the QNX4 and QNX6 OSes
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
