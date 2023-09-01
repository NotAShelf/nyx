{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  # SEE: https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/profiles/hardened.nix
  # this makes our system more secure
  # do note that it might break some stuff, e.g. webcam
  sys = config.modules.system;
in {
  security = {
    protectKernelImage = true;
    lockKernelModules = false; # breaks virtd, wireguard and iptables

    # force-enable the Page Table Isolation (PTI) Linux kernel feature
    forcePageTableIsolation = true;

    # User namespaces are required for sandboxing. Better than nothing imo.
    allowUserNamespaces = true;

    # Disable unprivileged user namespaces, unless containers are enabled
    unprivilegedUsernsClone = config.virtualisation.containers.enable;

    # apparmor configuration
    apparmor = {
      enable = true;
      killUnconfinedConfinables = true;
      packages = [pkgs.apparmor-profiles];
    };

    # virtualisation
    virtualisation = {
      #  flush the L1 data cache before entering guests
      flushL1DataCache = "always";
    };

    # log polkit request actions
    polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        polkit.log("user " +  subject.user + " is attempting action " + action.id + " from PID " + subject.pid);
      });
    '';

    # system audit
    auditd.enable = sys.security.auditd.enable;
    audit = {
      enable = sys.security.auditd.enable;
      backlogLimit = 8192;
      failureMode = "printk";
      rules = [
        "-a exit,always -F arch=b64 -S execve"
      ];
    };

    pam = {
      # fix "too many files open"
      loginLimits = [
        {
          domain = "@wheel";
          item = "nofile";
          type = "soft";
          value = "524288";
        }
        {
          domain = "@wheel";
          item = "nofile";
          type = "hard";
          value = "1048576";
        }
      ];

      services = {
        swaylock.text = "auth include login";
        gtklock.text = "auth include login";
      };
    };

    sudo = {
      wheelNeedsPassword = false;
      enable = mkDefault true;
      execWheelOnly = true;
      extraConfig = ''
        Defaults lecture = never # rollback results in sudo lectures after each reboot
        Defaults pwfeedback
        Defaults env_keep += "EDITOR PATH"
        Defaults timestamp_timeout = 300
        Defaults passprompt="[31m sudo: password for %p@%h, running as %U:[0m "
      '';
    };
  };

  boot.kernel.sysctl = {
    # The Magic SysRq key is a key combo that allows users connected to the
    # system console of a Linux kernel to perform some low-level commands.
    # Disable it, since we don't need it, and is a potential security concern.
    "kernel.sysrq" = 0;
    # Restrict ptrace() usage to processes with a pre-defined relationship
    # (e.g., parent/child)
    "kernel.yama.ptrace_scope" = 2;
    # Hide kptrs even for processes with CAP_SYSLOG
    "kernel.kptr_restrict" = 2;
    # Disable bpf() JIT (to eliminate spray attacks)
    "net.core.bpf_jit_enable" = false;
    # Disable ftrace debugging
    "kernel.ftrace_enabled" = false;
  };

  boot.blacklistedKernelModules =
    [
      # Obscure network protocols
      "ax25"
      "netrom"
      "rose"
      # Old or rare or insufficiently audited filesystems
      "adfs"
      "affs"
      "bfs"
      "befs"
      "cramfs"
      "efs"
      "erofs"
      "exofs"
      "freevxfs"
      "f2fs"
      "vivid"
      "gfs2"
      "ksmbd"
      "nfsv4"
      "nfsv3"
      "cifs"
      "nfs"
      "cramfs"
      "freevxfs"
      "jffs2"
      "hfs"
      "hfsplus"
      "squashfs"
      "udf"
      "hpfs"
      "jfs"
      "minix"
      "nilfs2"
      "omfs"
      "qnx4"
      "qnx6"
      "sysv"
    ]
    ++ lib.optionals (!sys.security.fixWebcam) [
      "uvcvideo" # this is why your webcam no worky
    ]
    ++ lib.optionals (!sys.bluetooth.enable) [
      "btusb" # let bluetooth dongles work
    ];
}
