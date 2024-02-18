{
  inputs',
  pkgs,
  ...
}: let
  inherit (inputs'.hyprland-contrib.packages) grimblast;
  inherit (inputs'.hyprpicker.packages) hyprpicker;

  wrapper = pkgs.callPackage ./wrapper {inherit (inputs') hyprland;};
  hyprshot = pkgs.callPackage ./hyprshot.nix {};
  dbus-hyprland-env = pkgs.callPackage ./dbus-hyprland-env.nix {};
  propaganda = pkgs.callPackage ./propaganda.nix {};
in {
  inherit grimblast hyprpicker wrapper hyprshot dbus-hyprland-env propaganda;
}
