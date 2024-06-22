{self, ...}: {
  system = {
    # Automatic/Unattended upgrades in general are one of the dumbest things you can set up
    # on virtually any Linux distribution. While NixOS would logically mitigate some of its
    # side effects, you are still risking a system that breaks without you knowing. If the
    # bootloader also breaks during the upgrade, you may not be able to roll back at all.
    # tl;dr: upgrade manually, review changelogs.
    autoUpgrade.enable = false;

    # Globally declare the configurationRevision from shortRev if the git tree is clean,
    # or from dirtyShortRev if it is dirty. This is useful for tracking the current
    # configuration revision in the system profile.
    configurationRevision = self.shortRev or self.dirtyShortRev;
  };
}
