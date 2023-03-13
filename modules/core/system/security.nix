{
  config,
  pkgs,
  lib,
  ...
}: let
  # this makes our system more secure
  # note that it might break some stuff, e.g. webcam
  sys = config.modules.system.security;
in {
  programs.ssh.startAgent = true;

  security = {
    protectKernelImage = true;
    lockKernelModules = true;
    forcePageTableIsolation = true;

    apparmor = {
      enable = true;
      killUnconfinedConfinables = true;
      packages = [pkgs.apparmor-profiles];
    };

    auditd.enable = true;
    audit = {
      enable = true;
      rules = [
        "-a exit,always -F arch=b64 -S execve"
      ];
    };

    pam = {
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
        greetd.gnupg.enable = true;
        login.enableGnomeKeyring = true;
        swaylock = {
          text = ''
            auth include login
          '';
        };
      };
    };

    # doas is cool, I like doas
    sudo.enable = lib.mkDefault false;
    doas = {
      enable = lib.mkDefault true;
      extraRules = [
        {
          groups = ["wheel"];
          persist = true;
          keepEnv = false;
        }
        {
          groups = ["power"];
          noPass = true;
          cmd = "${pkgs.systemd}/bin/poweroff";
        }
        {
          groups = ["power"];
          noPass = true;
          cmd = "${pkgs.systemd}/bin/reboot";
        }
        {
          groups = ["nix"];
          cmd = "nix-collect-garbage";
          noPass = true;
        }
        {
          groups = ["nix"];
          cmd = "nixos-rebuild";
          keepEnv = true;
        }
      ];
    };
  };

  boot.kernel.sysctl = {
    # The Magic SysRq key is a key combo that allows users connected to the
    # system console of a Linux kernel to perform some low-level commands.
    # Disable it, since we don't need it, and is a potential security concern.
    "kernel.sysrq" = 0;
    "kernel.yama.ptrace_scope" = 2;
    "kernel.kptr_restrict" = 2;
    "net.core.bpf_jit_enable" = false;
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
      "btusb"
      "hpfs"
      "jfs"
      "minix"
      "nilfs2"
      "omfs"
      "qnx4"
      "qnx6"
      "sysv"
    ]
    ++ lib.optionals (!sys.fixWebcam) [
      "uvcvideo" # this is why your webcam no worky
    ];
}
