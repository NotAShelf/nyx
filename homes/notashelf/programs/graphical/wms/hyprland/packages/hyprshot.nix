{pkgs, ...}:
pkgs.writeShellApplication {
  name = "hyprshot";
  runtimeInputs = with pkgs; [grim slurp swappy];
  text = ''
    hyprctl keyword animation "fadeOut,0,8,slow" && \
      grim -g "$(slurp -w 0 -b 5e81acd2)" - | swappy -f -; \
      hyprctl keyword animation "fadeOut,1,8,slow"
  '';
}
