{lib, ...}:
with lib; {
  imports = [
    ./programs
    ./services
  ];
  options.modules = {
    programs = {
    };
  };
}
