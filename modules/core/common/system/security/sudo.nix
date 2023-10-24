{lib, ...}: {
  security = {
    # no, you are not brekaing my system because of "muh rust" again
    # sudo-rs is still a feature-incomplete sudo fork that can and will mess things up
    # also for the love of god stop rewriting things in rust
    sudo-rs.enable = lib.mkForce false;

    # the ol' reliable
    sudo = {
      enable = true;

      # wheelNeedsPassword = false means wheel group can execute commands without a password
      # this is especially useful if you are using --target-host option in nixos-rebuild switch
      # however it's also a massive security flaw - which is why it should be replaced with the
      # extraRules you will see below
      wheelNeedsPassword = true;

      # only allow members of the wheel group to execute sudo
      # by setting the executable’s permissions accordingly
      execWheelOnly = true;

      extraConfig = ''
        Defaults lecture = never # rollback results in sudo lectures after each reboot, it's somewhat useless anyway
        Defaults pwfeedback # password input feedback - makes typed password visible as asterisks
        Defaults env_keep += "EDITOR PATH" # variables that will be passed to the root account
        Defaults timestamp_timeout = 300 # makes sudo ask for password less often
      '';

      extraRules = [
        {
          # allow wheel group to run nixos-rebuild without password
          # this is a less vulnerable alternative to having wheelNeedsPassword = false
          groups = ["sudo" "wheel"];
          commands = [
            {
              command = "/run/current-system/bin/switch-to-configuration";
              options = ["NOPASSWD"];
            }
            {
              command = "/run/current-system/sw/bin/nix-collect-garbage";
              options = ["NOPASSWD"];
            }
          ];
        }
      ];
    };
  };
}
