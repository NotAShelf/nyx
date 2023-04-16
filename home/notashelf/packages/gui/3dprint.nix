{pkgs, ...}: {
  config = {
    home.packages = with pkgs; [
      freecad
      prusa-slicer
    ];
  };
}
