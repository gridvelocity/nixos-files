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
    boot.consoleLogLevel = 3;
  boot.initrd.verbose = false;

  boot.kernelParams = [
    "quiet"
    "splash"
    "rd.udev.log_level=3"
    "rd.systemd.show_status=auto"
    "udev.log_priority=3"
  ];
}
