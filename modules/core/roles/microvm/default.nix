{
  imports = [
    ./programs
    ./users

    ./environment.nix
    ./networking.nix
    ./nix.nix
  ];

  config = {
    nix.settings.trusted-users = ["admin"];
    security.sudo.extraRules = [
      {
        users = ["admin"];
        commands = [
          {
            command = "ALL";
            options = ["SETENV" "NOPASSWD"];
          }
        ];
      }
    ];
  };
}
