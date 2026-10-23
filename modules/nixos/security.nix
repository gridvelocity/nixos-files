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


  nixpkgs.overlays = [
    (final: prev: {
      libfprint-2-tod1-vfs0090 = prev.libfprint-2-tod1-vfs0090.overrideAttrs (old: {
        patches = (old.patches or []) ++ [
          ../../patches/vfs0090-libfprint-1.94.patch
        ];
        meta = old.meta // { broken = false; };
      });
    })
  ];

let
  # Pull the dedicated Validity standalone service tools directly into the module
  open-fprintd = pkgs.callPackage "${pkgs.path}/pkgs/development/tools/biometric/open-fprintd" {};
  python-validity = pkgs.callPackage "${pkgs.path}/pkgs/development/tools/biometric/python-validity" {};
in
{
  # Disable the standard brittle fprintd service entirely
  services.fprintd.enable = false;

  # Install the robust standalone tools directly into the system environment
  environment.systemPackages = [
    open-fprintd
    pkgs.fprintd # Provides the user space client tools like fprintd-enroll
    python-validity
  ];

  # Enable the dedicated background service daemons directly
  systemd.packages = [ open-fprintd python-validity ];
  systemd.services.open-fprintd.enable = true;
  systemd.services.python3-validity.enable = true;

  # Grant hardware access permissions to your user group
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="138a", ATTR{idProduct}=="0090", MODE="0666", GROUP="wheel"
  '';

  # Allow the fingerprint daemon to handle sudo prompts
  security.pam.services.sudo.fprintAuth = true;
}
