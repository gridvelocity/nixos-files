{ config, lib, pkgs, ... }:

{
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    devices = [ "nodev" ];

    gfxmodeEfi = "1920x1080";
    gfxmodeBios = "1920x1080";

    theme = pkgs.stdenv.mkDerivation {
      pname = "local-grub-theme";
      version = "1.0";
      src = ../../kasane-teto;

      installPhase = ''
        mkdir -p $out
        cp -r * $out/
      '';
    };
  };
  boot.plymouth = {
    enable = true;
    theme = "minimal-dark";

    themePackages = [
      (pkgs.callPackage ../../extras/plymouth/default.nix {})
    ];
  };
}
