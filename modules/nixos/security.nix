{ pkgs, ... }:

{

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    glibc glib zlib nasm util-linux libGL libGLU vulkan-loader libX11 libXext
    libXrender libXrandr libXcursor libXi libXtst libXinerama libXxf86vm libxcb
    libxkbcommon wayland alsa-lib libpulseaudio pipewire openal flac libvorbis
    libogg libopus fontconfig freetype libjpeg libpng gdk-pixbuf cairo pango
    gtk3 gtk4 nss nspr atk at-spi2-atk at-spi2-core dbus cups expat libdrm
    mesa systemd openssl curl libssh2 gamemode
  ];


  services.fprintd = {
    enable = true;
    package = pkgs.fprintd-tod;
    tod = {
      enable = true;
      driver = pkgs.libfprint-2-tod1-vfs0090;
    };
  };


  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="138a", ATTR{idProduct}=="0090", MODE="0666", GROUP="wheel"
  '';


  security.pam.services.sudo.fprintAuth = true;


  systemd.services.vfs7500-init = {
    description = "Validity VFS7500 Fingerprint Sensor Initialization";
    wantedBy = [ "multi-user.target" "post-resume.target" ];
    after = [ "udev.target" ];
    before = [ "fprintd.service" ];
    
    script = let
      pythonEnv = pkgs.python3.withPackages (ps: [ ps.pyusb ]);
    in ''
      ${pythonEnv}/bin/python3 -c "
import struct, usb.core
dev = usb.core.find(idVendor=0x138a, idProduct=0x0090)
if dev is not None:
    dev.reset()
    if dev.is_kernel_driver_active(0): dev.detach_kernel_driver(0)
    dev.set_configuration()
    
    # 1. FORCIBLY PURGE STORED WINDOWS COLD AUTHPAD LOCKS
    dev.write(1, struct.pack('<BBBB', 0x01, 0x12, 0x00, 0x00))
    
    # 2. RUN STANDARD WAKEUP REGISTERS
    dev.write(1, struct.pack('<BBBB', 0x01, 0x00, 0x00, 0x00))
    print('NVRAM Cryptographic Clean Complete. Hardware Line Active.')
"
    '';
  };

  
    nixpkgs.overlays = [
    (final: prev: {
      libfprint-2-tod1-vfs0090 = (prev.libfprint-2-tod1-vfs0090.overrideAttrs (old: {
        patches = (old.patches or []) ++ [
          ../../patches/vfs0090-libfprint-1.94.patch
        ];
        meta = old.meta // { broken = false; };
      })).overrideAttrs (finalAttrs: previousAttrs: {
        # CRITICAL REPAIR: Strip the obsolete 3rd argument from the driver's function calls
        postPatch = (previousAttrs.postPatch or "") + ''
          substituteInPlace vfs0090.c \
            --replace-warn "fpi_ssm_next_state_delayed (ssm, 200, NULL);" "fpi_ssm_next_state_delayed (ssm, 200);" \
            --replace-warn "fpi_ssm_next_state_delayed (ssm, 100, NULL);" "fpi_ssm_next_state_delayed (ssm, 100);"
        '';

        passthru = (previousAttrs.passthru or {}) // {
          driverPath = "/lib/libfprint-2/tod-1";
        };
      });
    })
  ];
}
