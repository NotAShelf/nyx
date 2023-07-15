pkgs: {
  wl-clipboard-plugin = pkgs.fetchFromGitHub {
    owner = "sayanarijit";
    repo = "wl-clipboard.xplr";
    rev = "a3ffc87460c5c7f560bffea689487ae14b36d9c3";
    hash = "sha256-I4rh5Zks9hiXozBiPDuRdHwW5I7ppzEpQNtirY0Lcks=";
  };
  nuke-plugin = pkgs.fetchFromGitHub {
    owner = "Junker";
    repo = "nuke.xplr";
    rev = "f83a7ed58a7212771b15fbf1fdfb0a07b23c81e9";
    hash = "sha256-k/yre9SYNPYBM2W1DPpL6Ypt3w3EMO9dznHwa+fw/n0=";
  };
}
