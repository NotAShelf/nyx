{pkgs, ...}: {
  config = {
    home.packages = with pkgs; [
      wlogout
      swappy
    ];
  };
}
