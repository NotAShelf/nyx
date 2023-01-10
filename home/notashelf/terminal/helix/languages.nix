{
  pkgs,
  lib,
  inputs,
  config,
  ...
}:
with pkgs; [
  {
    name = "typescript";
    auto-format = true;
    language-server = {
      command = "${nodePackages.typescript-language-server}/bin/typescript-language-server";
      args = ["--stdio"];
    };
    formatter = {
      command = "${nodePackages.prettier}/bin/prettier";
    };
  }
  {
    name = "cpp";
    auto-format = true;
    language-server = {
      command = "${clang-tools}/bin/clangd";
    };
    formatter = {
      command = "${clang-tools}/bin/clang-format";
      args = ["-i"];
    };
  }
  {
    name = "css";
    auto-format = true;
  }
  {
    name = "go";
    auto-format = true;
    language-server = {
      command = "${gopls}/bin/gopls";
    };
    formatter = {
      command = "${go}/bin/gofmt";
    };
  }
  {
    name = "javascript";
    auto-format = true;
    language-server = {
      command = "${nodePackages.typescript-language-server}/bin/typescript-language-server";
      args = ["--stdio"];
    };
  }
  {
    name = "nix";
    auto-format = true;
    language-server = {command = lib.getExe inputs.nil.packages.${system}.default;};
    config.nil.formatting.command = ["alejandra" "-q"];
    roots = ["flake.nix" "flake.json"];
  }
  {
    name = "rust";
    auto-format = true;
    language-server = {
      command = "${rust-analyzer}/bin/rust-analyzer";
    };
    formatter = {
      command = "${rustfmt}/bin/rustfmt";
    };
  }
]
