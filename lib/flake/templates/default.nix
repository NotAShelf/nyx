{
  c = {
    description = "C/C++ environment (clang)";
    path = ./c;
  };

  document = {
    description = "Document building environment (pandoc)";
    path = ./document;
  };

  rust = {
    description = "Rust environment (cargo)";
    path = ./rust;
  };

  zip = {
    description = "Simple Zip package";
    path = ./zip;
  };
}
