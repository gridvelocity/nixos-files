{ pkgs, ... }:

{
  programs.nix-ld.enable = true;

  programs.nix-ld.libraries = with pkgs; [
    glibc
    glib
    zlib
    nasm
    util-linux
    libGL
    libGLU
    vulkan-loader
    libX11
    libXext
    libXrender
    libXrandr
    libXcursor
    libXi
    libXtst
    libXinerama
    libXxf86vm
    libxcb
    libxkbcommon
    wayland
    alsa-lib
    libpulseaudio
    pipewire
    openal
    flac
    libvorbis
    libogg
    libopus
    fontconfig
    freetype
    libjpeg
    libpng
    gdk-pixbuf
    cairo
    pango
    gtk3
    gtk4
    nss
    nspr
    atk
    at-spi2-atk
    at-spi2-core
    dbus
    cups
    expat
    libdrm
    mesa
    systemd
    openssl
    curl
    libssh2
    gamemode
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
}
