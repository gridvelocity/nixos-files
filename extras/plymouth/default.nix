{ stdenvNoCC }:

stdenvNoCC.mkDerivation {
  pname = "minimal-dark-plymouth";
  version = "1.0";

  src = ./.;

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/plymouth/themes/minimal-dark

    cp minimal-dark.plymouth \
       minimal-dark.script \
       background.png \
       bar-background.png \
       bar-fill.png \
       logo.png \
       $out/share/plymouth/themes/minimal-dark/
  '';
}