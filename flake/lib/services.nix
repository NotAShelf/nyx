{lib, ...}: let
  inherit (lib.attrsets) recursiveUpdate;

  # make a service that is a part of the graphical session target
  mkGraphicalService = recursiveUpdate {
    Unit.PartOf = ["graphical-session.target"];
    Unit.After = ["graphical-session.target"];
    Install.WantedBy = ["graphical-session.target"];
  };

  # make a service that is a part of the hyprland session target
  mkHyprlandService = recursiveUpdate {
    Unit.PartOf = ["graphical-session.target"];
    Unit.After = ["graphical-session.target"];
    Install.WantedBy = ["hyprland-session.target"];
  };
in {
  inherit mkGraphicalService mkHyprlandService;
}
