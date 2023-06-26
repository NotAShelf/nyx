{
  shellCommands = [
    {
      help = "Format the source tree with treefmt";
      name = "fmt";
      command = "treefmt";
    }
    {
      help = "Format nix files with Alejandra";
      name = "alejandra";
      package = "alejandra";
    }
    {
      help = "Fetch source from origin";
      name = "pull";
      command = "git pull";
    }
  ];

  env = [
    {
      # nh requires the FLAKE env var to be set
      name = "FLAKE";
      value = builtins.exec "pwd";
    }
    {
      # make direnv shut up
      name = "DIRENV_LOG_FORMAT";
      value = "";
    }
  ];
}
