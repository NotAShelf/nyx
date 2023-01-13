{
  obsidian,
  nodePackages,
  gnused,
}:
obsidian.overrideAttrs (_: {
  __nocachix = true;
  patchPhase = ''
    ${nodePackages.asar}/bin/asar extract resources/obsidian.asar resources/obsidian
    rm resources/obsidian.asar
    ${gnused}/bin/sed -i 's/frame: false/frame: true/' resources/obsidian/main.js
    ${nodePackages.asar}/bin/asar pack resources/obsidian resources/obsidian.asar
    rm -rf resources/obsidian
  '';
})
