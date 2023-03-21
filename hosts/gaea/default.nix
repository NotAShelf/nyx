{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  # FIXME: for some reason, we cannot boot off ventoy
  # and have to burn the iso to an entire USB with dd
  # dd if=result/iso/*.iso of=/dev/sdX status=progress #

  # use networkmanager in the live environment
  networking.networkmanager.enable = lib.mkForce true;
  networking.wireless.enable = lib.mkForce false;

  # Enable SSH in the boot process.
  systemd.services.sshd.wantedBy = pkgs.lib.mkForce ["multi-user.target"];
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCpSqOPiFLyE4X+7CoV2b7iAmqsV1vsfiwyKd4Vmz8oVEaiRGBL9m6WYDMn/MwUF+cFsQ9RixfvpV1p0SyO05aNMHcO38efPkar6WLtYid0WoMdalWuC2RJh2ZB3AJXbY2JsDOiGM6r7iR/ZsFZyARaCnGLTHqZqKv6zZBl2snxsiZyXfsqmWNMlh8lTkTkK59ktBz+/c7AC9vx8eiCG/nBZFR0lXKNFODRgt2iYBkWdCTpAAaZa1S3QgbuxdhxefMtyrCTbUpunPuMixoO5TB8L0rvz2J3HuqkkjQ5vHJuHe5BIY+PbT3wJifWR7fILpLl28CbfMIivuSPt/WI7kk1q8x5UonRTEeEIALDmN46jg2Hibn6k1fyWH6U8thsH6zLNrpNL0lpiQM2nqs0hbEFht/D8JghdXHgWtfI/BbOTnl6XEbnZpvlJzdy0IkfmIn3VCjXQ7LocMC0PxsGzi6E4fhUAZ9gueY+gXgLrWP6e14SeceyizZPfqTaIuky498= notashelf@notapc"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCzp/3hogooArvQN+UMwzPA9CXY+Ch7x8eBRjMYR1A9/UDHIPEa/Pcwgat/v2Ciscejbg+3Hpy2L1KHpUKIzIXRw3vySGzFBT4tYBI8/85fw/pTvH+o9gm1jsODCDQprCtbQoX09ZxZQYmMh94UJehPNM3ZHP6qS98EfJvv3plg/JG7cYIag65UPJ6gfcwCKo3ZDIx9szbV3YzsnQFhgnIyK822s9lBQ9C0UDumUiGJeOP35cOVf9ZsLhNhP8Zv4E6F3DzxlCon/ysHF3bzK9bq8yFJgJCeQtTnEBFcQAE7oYh/m5CrMGXcKpILAWESVAw/FdAr5bS08+7+8xp+brgTWWiKMPRWlwS+FL0DfHYp0ftXJFPH6eWu7gdCSLrlSl/ZktWHr5nOgFFHUQBYWo+4W1Kj/vlT9OxqEcnGkoj5raCCDF9RHG6RXjH27e5vjFk0pBQP3IvUIeRzcw1miMiQYBwSzA6CXZwVLaTvfjCywr+CjEgOfA3dMS+p38Ew8SE= notashelf@prometheus"
  ];

  # use the latest Linux kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Needed for https://github.com/NixOS/nixpkgs/issues/58959
  boot.supportedFilesystems = lib.mkForce [
    "btrfs"
    "vfat"
    "f2fs"
    "xfs"
    "ntfs"
    "cifs"
  ];

  # system packages for the base installer
  environment.systemPackages = with pkgs; [git neovim netcat];
  users.extraUsers.root.password = "";

  # console locale #
  console = let
    variant = "u24n";
  in {
    # hidpi terminal font
    font = "${pkgs.terminus_font}/share/consolefonts/ter-${variant}.psf.gz";
    keyMap = "trq";
  };

  # attempt to fix "too many open files"
  security.pam.loginLimits = [
    {
      domain = "*";
      item = "nofile";
      type = "-";
      value = "65536";
    }
  ];

  #boot.loader.grub.device = "nodev";

  # faster compression in exchange for larger iso size
  isoImage.squashfsCompression = "gzip -Xcompression-level 1";

  services.getty.helpLine =
    ''
      The "nixos" and "root" accounts have empty passwords.
      An ssh daemon is running. You then must set a password
      for either "root" or "nixos" with `passwd` or add an ssh key
      to /home/nixos/.ssh/authorized_keys be able to login.
      If you need a wireless connection, you may use networkmanager
      by invoking `nmcli` or `nmtui`, the ncurses interface.
    ''
    + optionalString config.services.xserver.enable ''
      Type `sudo systemctl start display-manager' to
      start the graphical user interface.
    '';

  # borrow some environment options from the minimal profile to save space
  environment.noXlibs = mkDefault true; # trim inputs

  # disable documentation
  documentation = {
    enable = mkDefault false;

    doc.enable = mkDefault false;

    info.enable = mkDefault false;
  };
}
