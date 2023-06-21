{
  shellCommands = [
    {
      help = "Format the source tree with treefmt";
      name = "fmt";
      command = "nix fmt";
    }
  ];

  env = [
    {
      name = "FLAKE";
      value = builtins.exec "pwd";
    }
    {
      name = "DIRENV_LOG_FORMAT";
      value = "";
    }
  ];
}
