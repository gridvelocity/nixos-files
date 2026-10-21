{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  programs.firefox.enable = true;
  services.flatpak.enable = true;

  environment.sessionVariables = {
    XDG_DATA_DIRS = [ "$HOME/.local/share:$XDG_DATA_DIRS" ];
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    fastfetch
    gnome-builder
    vesktop
    thunar
    gvfs
    glib
    usbutils
    bottles
    flatpak
    kitty
    waybar
    hyprpaper
    git
    rofi
    brightnessctl
    dunst
    grim
    powertop
    weathr
    peaclock
    slurp
    wl-clipboard
    bash-completion
    unzip
    xarchiver
    zip
    thunar-archive-plugin
    jetbrains.webstorm
    jetbrains.pycharm
    bluez
    python3Packages.python
    cmatrix
    fprintd
    obs-studio
    gnome-disk-utility
    vlc
    hyprlock
    ani-cli
    playerctl
    udiskie
    xc
    lxappearance
    home-manager
    pavucontrol
    brave

    (runCommand "local-custom-themes" {} ''
      mkdir -p $out/share/icons
      cp -r ${../../extras}/* $out/share/icons/
    '')
  ];
}
