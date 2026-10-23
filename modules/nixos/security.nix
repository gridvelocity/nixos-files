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
    tod = {
      enable = true;
      driver = pkgs.python3Packages.python-validity;
    };
  };

  # 2. Enable the hardware initialization service
  systemd.services.python-validity = {
    description = "Validity Fingerprint Sensor Service";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.python3Packages.python-validity}/bin/python-validity";
      Restart = "on-failure";
    };
  };

  security.pam.services.login.fprintAuth = true;
  security.pam.services.sudo.fprintAuth = true;
}
