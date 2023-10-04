{
  callPackage,
  clang-tools,
  gnumake,
  cmake,
  bear,
  libcxx,
  cppcheck,
  llvm,
  gdb,
  glm,
  SDL2,
  SDL2_gfx,
}: let
  mainPkg = callPackage ./default.nix {};
in
  mainPkg.overrideAttrs (oa: {
    nativeBuildInputs =
      [
        clang-tools # fix headers not found
        gnumake # builder
        cmake # another builder
        bear # bear.
        libcxx # stdlib for cpp
        cppcheck # static analysis
        llvm.lldb # debugger
        gdb # another debugger
        llvm.libstdcxxClang # LSP and compiler
        llvm.libcxx # stdlib for C++
        # libs
        glm
        SDL2
        SDL2_gfx
      ]
      ++ (oa.nativeBuildInputs or []);
  })
