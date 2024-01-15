{
  inputs',
  pkgs,
  ...
}: let
  inherit (inputs'.hyprland-contrib.packages) grimblast;
  inherit (inputs'.hyprpicker.packages) hyprpicker;

  hyprshot = pkgs.writeShellApplication {
    name = "hyprshot";
    runtimeInputs = with pkgs; [grim slurp swappy];
    text = ''
      hyprctl keyword animation "fadeOut,0,8,slow" && \
        grim -g "$(slurp -w 0 -b 5e81acd2)" - | swappy -f -; \
        hyprctl keyword animation "fadeOut,1,8,slow"
    '';
  };

  dbus-hyprland-env = pkgs.writeTextFile {
    name = "dbus-hyprland-env";
    destination = "/bin/dbus-hyprland-environment";
    executable = true;
    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=hyprland
      systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire wireplumber pipewire-media-session xdg-desktop-portal xdg-desktop-portal-hyprland
    '';
  };
in {
  inherit grimblast hyprpicker hyprshot dbus-hyprland-env;
}
